#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os
import sys
import shutil
import sqlite3
import math
import json
import re
from urllib.parse import quote, unquote
from time import sleep, time
from threading import Thread, Event

from bottle import route, post, template, static_file, abort, request, redirect, run  # pip install bottle  # 1.2

import dlnap  # https://github.com/ttopholm/dlnap

VIDEO_PATH = './static/mp4'  # mp4 file path
# DLNAP = None  # dlna player


class DMR_Tracker(Thread):
    """Digital Media Renderer"""
    state = None  # dmr device state
    dmr = None  # dmr device object

    def __init__(self, *args, **kwargs):
        super(DMR_Tracker, self).__init__(*args, **kwargs)
        self.__flag = Event()
        self.__flag.set()
        self.__running = Event()
        self.__running.set()
        self.discover_dmr()
        
    def discover_dmr(self):
        allDevices = dlnap.discover(name='', ip='', timeout=2, st=dlnap.URN_AVTransport_Fmt, ssdp_version=1)
        if len(allDevices) > 0:
            self.dmr = allDevices[0]  # self.dmr.name

    def run(self):
        while self.__running.isSet():
            self.__flag.wait()
            if self.dmr:
                try:
                    self.state = dlnap._xpath(self.dmr.position_info(), 's:Envelope/s:Body/u:GetPositionInfoResponse')
                    # print(self.state['TrackURI']) 
                    src = unquote(re.sub('http://.*/video/', '', self.state['TrackURI'][0]))
                    save_history(src, time_to_second(self.state['RelTime'][0]), time_to_second(self.state['TrackDuration'][0]))

                    statex = dlnap._xpath(self.dmr.info(), 's:Envelope/s:Body/u:GetTransportInfoResponse/CurrentTransportState')  # PAUSED_PLAYBACK
                    # if state != 'PLAYING':
                        # stop = True
                    # .get_volume.CurrentVolume
                except Exception as e:
                    # self.dmr = None
                    print(e)
                for i in range(1):
                    sleep(1)
                    print('tick: %s' % time())
                    # RelTime += 1
            else:
                self.discover_dmr()

    def pause(self):
        self.__flag.clear()

    def resume(self):
        self.__flag.set()

    def stop(self):
        self.__flag.set()
        self.__running.clear()  


# def discover_dlnap():
    # global DLNAP
    # if not DLNAP:
        # allDevices = dlnap.discover(name='', ip='', timeout=2, st=dlnap.URN_AVTransport_Fmt, ssdp_version=1)
        # if len(allDevices) > 0:
            # DLNAP = allDevices[0]


def run_sql(sql, *args):
    with sqlite3.connect('player.db') as conn:
        try:
            cursor = conn.execute(sql, args)
            result = cursor.fetchall()
            cursor.close()
            if cursor.rowcount > 0:
                conn.commit()
        except Exception as e:
            print(str(e))
            result = ()
    return result


def second_to_time(second):  # turn seconds into hh:mm:ss time format
    m, s = divmod(second, 60)
    h, m = divmod(second/60, 60)
    return '%02d:%02d:%02d' % (h, m, s)


def time_to_second(time_str):  # turn hh:mm:ss time format into seconds
    return sum([int(i)*60**n for n,i in enumerate(str(time_str).split(':')[::-1])])


def get_size(*filename):
    size = os.path.getsize('%s/%s' % (VIDEO_PATH, ''.join(filename)))
    if size < 0:
        return 'Out of Range'
    if size < 1024:
        return '%dB' % size
    else:
        unit = ('', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y', 'B')
        l = min(int(math.floor(math.log(size, 1024))), 9)
        return '%.1f%sB' % (size/1024.0**l, unit[l])


def load_history(name):
    position = run_sql('select POSITION from history where FILENAME=?', name)
    if len(position) == 0:
        return 0
    return position[0][0]


def save_history(src, position, duration):
    if position < 10 or duration < 10:
        return
    run_sql('''replace into history (FILENAME, POSITION, DURATION, LATEST_DATE)
               values(? , ?, ?, DateTime('now', 'localtime'));''', src, position, duration)


@route('/list')
def list_history():
    """Return play history list"""
    return json.dumps([{'filename': s[0], 'position': s[1], 'duration': s[2],
                        'latest_date': s[3], 'path': os.path.dirname(s[0])}
                       for s in run_sql('select * from history order by LATEST_DATE desc')])


@route('/')
def index():
    discover_dlnap()
    mode = 'index'
    if tracker.dmr:
        mode = 'dlna'
    return template('player', mode=mode, src='', position=0, title='Light mp4 Player')


@route('/dlna')
def dlna():
    return template('player', mode='dlna', src='', position=0, title='DMC - Light mp4 Player')


@route('/play/<src:re:.*\.((?i)mp)4$>')
def play(src):
    """Video play page"""
    if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
        redirect('/')
    return template('player', mode='player', src=src, position=load_history(src), title=src)


@route('/dlna/<src:re:.*\.((?i)(mp4|mkv|avi))$>')
def dlna_load(src):
    """Video DLNA play page"""
    if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
        return
    url = 'http://%s/video/%s' % (request.urlparts.netloc, quote(src))
    try:
        tracker.dmr.stop()
        sleep(0.8)
        tracker.dmr.set_current_media(url)
        tracker.dmr.play()
        position = load_history(src)
        if position:
            while tracker.state['TrackDuration'][0] == '00:00:00':
                print(tracker.state['TrackDuration'][0])
                sleep(0.1)
            print(second_to_time(position))
            tracker.dmr.seek(second_to_time(position))
    except Exception as e:
        print(e)
    return template('player', mode='dlna', src=src, position=0, title='DMC - %s' % src)


@route('/dlnaplay')
def dlna_play():
    """Play video through DLNA"""
    tracker.dmr.play()


@route('/dlnapause')
def dlna_pause():
    """Pause video through DLNA"""
    discover_dlnap()
    tracker.dmr.pause()


@route('/dlnastop')
def dlna_stop():
    """Stop video through DLNA"""
    tracker.dmr.stop()


@route('/dlnainfo')
def dlna_info():
    """Get play info through DLNA"""
    return tracker.state


@route('/dlnavolume/<v>')
def dlna_volume(v):
    """Set volume through DLNA"""
    tracker.dmr.volume(v)


@route('/dlnaseek/<position>')
def dlna_seek(position):
    """Seek video through DLNA"""
    tracker.dmr.seek(position)


@route('/clear')
def clear():
    """Clear play history list"""
    run_sql('delete from history')
    return list_history()


@route('/remove/<src:path>')
def remove(src):
    """Remove from play history list"""
    run_sql('delete from history where FILENAME= ?', src)
    return list_history()


@route('/move/<src:path>')
def move(src):
    """Move file to 'old' folder"""
    file = '%s/%s' % (VIDEO_PATH, src)
    dir_old = '%s/%s/old' % (VIDEO_PATH, os.path.dirname(src))
    if not os.path.exists(dir_old):
        os.mkdir(dir_old)
    try:
        shutil.move(file, dir_old)  # gonna do something when file is occupied
    except Exception as e:
        print(str(e))
        abort(404, str(e))
    return fs_dir('%s/' % os.path.dirname(src))


@post('/save/<src:path>')
def save(src):
    """Save play position"""
    position = request.forms.get('position')
    duration = request.forms.get('duration')
    save_history(src, position, duration)


@post('/suspend')
def suspend():
    """Suepend server"""
    if sys.platform == 'win32':
        import ctypes
        dll = ctypes.WinDLL('powrprof.dll')
        if dll.SetSuspendState(0, 1, 0):
            return 'Suspending...'
        else:
            return 'Suspend Failure!'
    else:
        return 'OS not supported!'


@post('/shutdown')
def shutdown():
    """Shutdown server"""
    if sys.platform == 'win32':
        os.system("shutdown.exe -f -s -t 0")
    else:
        os.system("sudo /sbin/shutdown -h now")
    return 'shutting down...'


@post('/restart')
def restart():
    """Restart server"""
    if sys.platform == 'win32':
        os.system('shutdown.exe -f -r -t 0')
    else:
        os.system('sudo /sbin/shutdown -r now')
    return 'restarting...'


@route('/static/<filename:path>')
def static(filename):
    """Static file access"""
    return static_file(filename, root='./static')


@route('/video/<src:re:.*\.((?i)(mp4|mkv|avi))$>')
def static_video(src):
    """video file access
       To support large file(>2GB), you should use web server to deal with static files.
       For example, you can use 'AliasMatch' or 'Alias' in Apache
    """
    return static_file(src, root=VIDEO_PATH)


@route('/fs/<path:re:.*>')
def fs_dir(path):
    """Get static folder list in json"""
    try:
        up, list_folder, list_mp4, list_video, list_other = [], [], [], [], []
        if path:
            up = [{'filename': '..', 'type': 'folder', 'path': '/%s..' % path}]
        for file in os.listdir('%s/%s' % (VIDEO_PATH, path)):
            if os.path.isdir('%s/%s%s' % (VIDEO_PATH, path, file)):
                list_folder.append({'filename': file, 'type': 'folder', 'path': '/%s%s' % (path, file)})
            elif re.match('.*\.((?i)mp)4$', file):
                list_mp4.append({'filename': file, 'type': 'mp4',
                                'path': '%s%s' % (path, file), 'size': get_size(path, file)})
            elif re.match('.*\.((?i)(mkv|avi))$', file):
                list_video.append({'filename': file, 'type': 'video',
                                'path': '%s%s' % (path, file), 'size': get_size(path, file)})
            else:
                list_other.append({'filename': file, 'type': 'other',
                                  'path': '%s%s' % (path, file), 'size': get_size(path, file)})
        return json.dumps(up + list_folder + list_mp4 + list_video + list_other)
    except Exception as e:
        abort(404, str(e))

os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current
# Initialize DataBase
run_sql('''create table if not exists history
                (FILENAME text PRIMARY KEY not null,
                POSITION float not null,
                DURATION float, LATEST_DATE datetime not null);''')
tracker = DMR_Tracker()
tracker.start()

if __name__ == '__main__':  # for debug
    # os.system('start http://127.0.0.1:8081/')  # open the page automatic
    # os.system('start http://127.0.0.1:8081/dlna/test.mp4')  # open the page automatic
    # run(host='0.0.0.0', port=8081, debug=True, reloader=True)  # run demo server
    run(host='0.0.0.0', port=8081, debug=True)  # run demo server
