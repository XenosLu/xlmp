#!/usr/bin/python3
# -*- coding:utf-8 -*-
import json
import math
import os
import re
import shutil
import sqlite3
import sys
import traceback
import logging

from threading import Thread, Event
from urllib.parse import quote, unquote
from time import sleep, time

os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current
sys.path = ['lib'] + sys.path  # added libpath

from bottle import abort, post, redirect, request, route, run, static_file, template  # v0.12
from dlnap import URN_AVTransport_Fmt, discover  # https://github.com/ttopholm/dlnap

# initialize logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s %(levelname)s [line:%(lineno)d] %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')

VIDEO_PATH = './media'  # media file path
HISTORY_FILE = 'history.db'  # history db file name


class DMRTracker(Thread):
    """Digital Media Renderer"""
    state = {}  # dmr device state
    dmr = None  # dmr device object
    all_devices = None  # dmr device object

    def __init__(self, *args, **kwargs):
        super(DMRTracker, self).__init__(*args, **kwargs)
        self.__flag = Event()
        self.__flag.set()
        self.__running = Event()
        self.__running.set()
        logging.info('DMR Tracker initialized.')

    def discover_dmr(self):
        logging.debug('Starting DMR search...')
        if self.dmr:
            logging.info('Current DMR: %s' % self.dmr)
        self.all_devices = discover(name='', ip='', timeout=3, st=URN_AVTransport_Fmt, ssdp_version=1)
        if len(self.all_devices) > 0:
            self.dmr = self.all_devices[0]
            logging.info('Found DMR device: %s' % self.dmr)

    def set_dmr(self, str_dmr):
        for i in self.all_devices:
            if str(i) == str_dmr:
                self.dmr = i
                return True
        return False

    def get_transport_state(self):
        try:
            return self.dmr.info()['CurrentTransportState']
        except:
            return

    def run(self):
        while self.__running.isSet():
            self.__flag.wait()
            if self.dmr:
                try:
                    self.state['CurrentDMR'] = str(self.dmr)
                    self.state['DMRs'] = [str(i) for i in self.all_devices]
                    self.state['CurrentVolume'] = self.dmr.get_volume()
                    if not self.state['CurrentVolume']:
                        logging.info('No DMR currently.')
                        self.dmr = None
                        continue
                    self.state['CurrentTransportState'] = self.dmr.info()['CurrentTransportState']
                    position_info = self.dmr.position_info()
                    for i in ('RelTime', 'TrackDuration'):
                        self.state[i] = position_info[i]
                    if self.state['CurrentTransportState'] == 'PLAYING':
                        self.state['TrackURI'] = unquote(re.sub('http://.*/video/', '', position_info['TrackURI']))
                        save_history(self.state['TrackURI'], time_to_second(self.state['RelTime']),
                                     time_to_second(self.state['TrackDuration']))
                except TypeError as e:
                    logging.warning('TypeError: %s\n%s' % (e, traceback.format_exc()))
                except Exception as e:
                    logging.warning('DMR Tracker Exception: %s\n%s' % (e, traceback.format_exc()))
                sleep(1)
            else:
                self.discover_dmr()
                sleep(4)

    def pause(self):
        self.__flag.clear()

    def resume(self):
        self.__flag.set()

    def stop(self):
        self.__flag.set()
        self.__running.clear()


def run_sql(sql, *args):
    with sqlite3.connect(HISTORY_FILE) as conn:
        try:
            cursor = conn.execute(sql, args)
            result = cursor.fetchall()
            cursor.close()
            if cursor.rowcount > 0:
                conn.commit()
        except Exception as e:
            logging.warning(str(e))
            result = ()
    return result


def second_to_time(second):
    """ Turn time in seconds into "hh:mm:ss" format
    
    second: int value
    """
    m, s = divmod(second, 60)
    h, m = divmod(second/60, 60)
    return '%02d:%02d:%02d' % (h, m, s)


def time_to_second(time_str):
    """ Turn time in "hh:mm:ss" format into seconds
    
    time_str: string like "hh:mm:ss"
    """
    return sum([int(i)*60**n for n, i in enumerate(str(time_str).split(':')[::-1])])


def get_size(*filename):
    size = os.path.getsize('%s/%s' % (VIDEO_PATH, ''.join(filename)))
    if size < 0:
        return 'Out of Range'
    elif size < 1024:
        return '%dB' % size
    else:
        unit = ' KMGTPEZYB'
        l = min(int(math.floor(math.log(size, 1024))), 9)
        return '%.1f%sB' % (size/1024.0**l, unit[l])


def load_history(name):
    position = run_sql('select POSITION from history where FILENAME=?', name)
    if len(position) == 0:
        return 0
    return position[0][0]


def save_history(src, position, duration):
    if float(position) < 10 or float(duration) < 10:
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
    if tracker.dmr:
        redirect('/dlna')
    return template('index.tpl')


@route('/index')
def index_o():
    return template('index.tpl')


@route('/dlna')
def dlna():
    return template('dlna_player.tpl')


@route('/play/<src:re:.*\.((?i)mp)4$>')
def play(src):
    """Video play page"""
    if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
        redirect('/')
    return template('player.tpl', src=src, title=src, position=load_history(src))


@route('/setdmr/<dmr>')
def set_dlna_dmr(dmr):
    if tracker.set_dmr(dmr):
        return 'Success'
    else:
        return 'Failed'


@route('/searchdmr')
def search_dmr():
    tracker.discover_dmr()


@route('/dlnaload/<src:re:.*\.((?i)(mp4|mkv|avi|flv|rmvb))$>')
def dlna_load(src):
    """Video DLNA play page"""
    if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
        abort(404, 'File not found.')
    if not tracker.dmr:
        abort(500, 'no DMR.')
    logging.info('start loading... tracker state:%s' % tracker.state)
    url = 'http://%s/video/%s' % (request.urlparts.netloc, quote(src))
    try:  # set trackuri, if failed stop and retry
        # while tracker.state['CurrentTransportState'] not in ('STOPPED', 'NO_MEDIA_PRESENT'):
        # while tracker.dmr.info()['CurrentTransportState'] not in ('STOPPED', 'NO_MEDIA_PRESENT'):
        while tracker.get_transport_state() not in ('STOPPED', 'NO_MEDIA_PRESENT'):
            tracker.dmr.stop()
            logging.info('waiting for stopping...current state: %s' % tracker.state['CurrentTransportState'])
            sleep(0.85)
        if tracker.dmr.set_current_media(url):
            logging.info('url loaded')
        # tracker.dmr.play()
        while tracker.get_transport_state() not in ('PLAYING', 'TRANSITIONING'):
        # while tracker.dmr.info()['CurrentTransportState'] not in ('PLAYING', 'TRANSITIONING'):
        # while tracker.state['CurrentTransportState'] not in ('PLAYING', 'TRANSITIONING'):
            tracker.dmr.play()
            logging.info('waiting for playing...current state: %s' % tracker.state['CurrentTransportState'])
            sleep(0.2)
        sleep(0.5)
        time0 = time()
        logging.info('checking duration to make sure loaded...')
        while tracker.dmr.position_info()['TrackDuration'] == '00:00:00':
        # while tracker.state['TrackDuration'] == '00:00:00':
            sleep(0.5)
            logging.info('Waiting for duration correctly recognized')
            if (time() - time0) > 10:
                logging.info('reload position: in %fs' % (time() - time0))
                dlna_load(src)
                return
        position = load_history(src)
        if position:
            tracker.dmr.seek(second_to_time(position))
            logging.info('loaded position: %s in %fs' % (second_to_time(position), time() - time0))
        logging.info(tracker.state)
    except Exception as e:
        logging.warning('DLNA load exception: %s\n%s' % (e, traceback.format_exc()))


@route('/dlnaplay')
def dlna_play():
    """Play video through DLNA"""
    try:
        tracker.dmr.play()
    except AttributeError as e:
        return 'no DMR'
    except Exception as e:
        return 'failed: %s' % e


@route('/dlnapause')
def dlna_pause():
    """Pause video through DLNA"""
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


@route('/dlnavolumeup/')
def dlna_volume_up():
    """Set volume through DLNA"""
    tracker.dmr.volume(tracker.dmr.get_volume() + 1)


@route('/dlnavolumedown/')
def dlna_volume_down():
    """Set volume through DLNA"""
    tracker.dmr.volume(tracker.dmr.get_volume() - 1)


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
    run_sql('delete from history where FILENAME=?', unquote(src))
    return list_history()


@route('/move/<src:path>')
def move(src):
    """Move file to 'old' folder"""
    filename = '%s/%s' % (VIDEO_PATH, src)
    dir_old = '%s/%s/old' % (VIDEO_PATH, os.path.dirname(src))
    if not os.path.exists(dir_old):
        os.mkdir(dir_old)
    try:
        shutil.move(filename, dir_old)  # gonna do something when file is occupied
    except Exception as e:
        logging.warning(str(e))
        abort(404, str(e))
    return fs_dir('%s/' % os.path.dirname(src))


@post('/save/<src:path>')
def save(src):
    """Save play position"""
    position = request.forms.get('position')
    duration = request.forms.get('duration')
    save_history(src, position, duration)


@route('/deploy')
def deploy():
    """deploy"""
    if sys.platform == 'win32':
        os.system("E:\\onedrive\\GitHub\\发布.cmd")
        return 'Sent.'


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


@route('/backup')
def backup():
    """backup history"""
    if sys.platform != 'win32':
        os.system('cp -f %s/%s %s/%s.bak' % (VIDEO_PATH, HISTORY_FILE, VIDEO_PATH, HISTORY_FILE))
        os.system('cp -f %s %s' % (HISTORY_FILE, VIDEO_PATH))
    redirect('/')


@route('/restore')
def restore():
    """restore history"""
    if sys.platform != 'win32':
        os.system('cp -f %s/%s .' % (VIDEO_PATH, HISTORY_FILE))
    redirect('/')


@route('/static/<filename:path>')
def static(filename):
    """Static file access"""
    return static_file(filename, root='./static')


@route('/video/<src:re:.*\.((?i)(mp4|mkv|avi|flv|rmvb))$>')
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
        dir_list = os.listdir('%s/%s' % (VIDEO_PATH, path))
        dir_list.sort()
        # for filename in os.listdir('%s/%s' % (VIDEO_PATH, path)):
        for filename in dir_list:
            if filename.startswith('.'):
                continue
            if os.path.isdir('%s/%s%s' % (VIDEO_PATH, path, filename)):
                list_folder.append({'filename': filename, 'type': 'folder',
                                    'path': '/%s%s' % (path, filename)})
            elif re.match('.*\.((?i)mp)4$', filename):
                list_mp4.append({'filename': filename, 'type': 'mp4',
                                'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
            elif re.match('.*\.((?i)(mkv|avi|flv|rmvb))$', filename):
                list_video.append({'filename': filename, 'type': 'video',
                                   'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
            else:
                list_other.append({'filename': filename, 'type': 'other',
                                  'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
        return json.dumps(up + list_folder + list_mp4 + list_video + list_other)
    except Exception as e:
        logging.warning('dir exception: %s pwd: %s' % (e, os.getcwd()))
        abort(404, str(e))

# Initialize DataBase
run_sql('''create table if not exists history
                (FILENAME text PRIMARY KEY not null,
                POSITION float not null,
                DURATION float, LATEST_DATE datetime not null);''')
tracker = DMRTracker()
tracker.start()

if __name__ == '__main__':  # for debug
    from imp import find_module
    if sys.platform == 'win32':
        os.system('start http://127.0.0.1:8081/')  # open the page automatic for debug
    try:
        find_module('meinheld')
        run(host='127.0.0.1', port=8081, debug=True, server='meinheld')  # run demo server use meinheld
    except:
        run(host='0.0.0.0', port=8081, debug=True)  # run demo server
