#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os
import sys
import shutil
import sqlite3
import math
import json
import re
from urllib.parse import quote

from bottle import route, post, template, static_file, abort, request, redirect, run  # pip install bottle  # 1.2

import dlnap  # https://github.com/cherezov/dlnap

VIDEO_PATH = './static/mp4'  # mp4 file path
URN_AVTransport_Fmt = "urn:schemas-upnp-org:service:AVTransport:{}"


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


def time_format(time):#turn seconds into hh:mm:ss time format
	m, s = divmod(time, 60)
	h, m = divmod(time/60, 60)
	return "%02d:%02d:%02d" % (h, m, s)


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
    progress = run_sql('select PROGRESS from history where FILENAME=?', name)
    if len(progress) == 0:
        return 0
    return progress[0][0]


@route('/list')
def list_history():
    """Return play history list"""
    return json.dumps([{'filename': s[0], 'progress': s[1], 'duration': s[2],
                        'latest_date': s[3], 'path': os.path.dirname(s[0])}
                       for s in run_sql('select * from history order by LATEST_DATE desc')])


@route('/')
def index():
    return template('player', mode='index', src='', progress=0, title='Light mp4 Player')


@route('/play/<src:re:.*\.((?i)mp)4$>')
def play(src):
    """Video play page"""
    if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
        redirect('/')
    return template('player', mode='player', src=src, progress=load_history(src), title=src)

@route('/dlna/<src:re:.*\.((?i)(mp4|mkv))$>')
def dlna(src):
    """Video DLNA play page"""
    return template('player', mode='dlna', src=src, progress=0, title="DLNA - %s" % src)


@route('/dlnaplay/<src:re:.*\.((?i)(mp4|mkv))$>')
def dlna_play(src):
    """Play video through DLNA"""
    url = 'http://192.168.2.100/mp4/%s' % quote(src)
    allDevices = dlnap.discover(name='', ip='', timeout=2, st=URN_AVTransport_Fmt, ssdp_version=1)
    d = allDevices[0]
    try:
        d.set_current_media(url=url)
        d.play()
    except Exception as e:
        print('Device is unable to play media.')
        print('Play exception:\n{}'.format(traceback.format_exc()))
    run_sql('''replace into history (FILENAME, PROGRESS, DURATION, LATEST_DATE)
               values(? , ?, ?, DateTime('now', 'localtime'));''', src, 0, 0)
    return ''


@route('/dlnapause')
def dlna_pause():
    """Play video through DLNA"""
    allDevices = dlnap.discover(name='', ip='', timeout=2, st=URN_AVTransport_Fmt, ssdp_version=1)
    d = allDevices[0]
    try:
        d.pause()
    except Exception as e:
        print('Device is unable to pause.')
        print('Play exception:\n{}'.format(traceback.format_exc()))
    return ''


@route('/dlnavolume/<v>')
def dlna_volume(v):
    """Play video through DLNA"""
    allDevices = dlnap.discover(name='', ip='', timeout=2, st=URN_AVTransport_Fmt, ssdp_version=1)
    d = allDevices[0]
    try:
        d.volume(v)
    except Exception as e:
        print('Device is unable to set volume.')
        print('Play exception:\n{}'.format(traceback.format_exc()))
    return ''


@route('/dlnaseek/<position>')
def dlna_seek(position):
    """Play video through DLNA"""
    allDevices = dlnap.discover(name='', ip='', timeout=2, st=URN_AVTransport_Fmt, ssdp_version=1)
    d = allDevices[0]
    try:
        d.seek(position)
    except Exception as e:
        print('Device is unable to seek.')
        print('Play exception:\n{}'.format(traceback.format_exc()))
    return ''


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
    """Save play progress"""
    progress = request.forms.get('progress')
    duration = request.forms.get('duration')
    run_sql('''replace into history (FILENAME, PROGRESS, DURATION, LATEST_DATE)
               values(? , ?, ?, DateTime('now', 'localtime'));''', src, progress, duration)
    return


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
        os.system("shutdown.exe -f -r -t 0")
    else:
        os.system("sudo /sbin/shutdown -r now")
    return 'restarting...'


@route('/static/<filename:path>')
def static(filename):
    """Static file access"""
    return static_file(filename, root='./static')


# @route('/mp4/<src:re:.*\.((?i)mp)4$>')
@route('/mp4/<src:re:.*\.((?i)(mp4|mkv))$>')
def static_mp4(src):
    """mp4 file access
       To support large file(>2GB), you should use web server to deal with static files.
       For example, you can use "AliasMatch"/"Alias" in Apache
    """
    return static_file(src, root=VIDEO_PATH)


@route('/video/<src:re:.*\.((?i)(mp4|mkv))$>')
def static_video(src):
    """video file access
       To support large file(>2GB), you should use web server to deal with static files.
       For example, you can use "AliasMatch"/"Alias" in Apache
    """
    return static_file(src, root=VIDEO_PATH)


@route('/fs/<path:re:.*>')
def fs_dir(path):
    """Get static folder list in json"""
    try:
        list_folder, list_mp4, list_mkv, list_other = [], [], [], []
        if path == '':
            up = []
        else:
            up = [{'filename': '..', 'type': 'folder', 'path': '/%s..' % path}]
        for file in os.listdir('%s/%s' % (VIDEO_PATH, path)):
            if os.path.isdir('%s/%s%s' % (VIDEO_PATH, path, file)):
                list_folder.append({'filename': file, 'type': 'folder', 'path': '/%s%s' % (path, file)})
            elif re.match('.*\.((?i)mp)4$', file):
                list_mp4.append({'filename': file, 'type': 'mp4',
                                'path': '%s%s' % (path, file), 'size': get_size(path, file)})
            elif re.match('.*\.((?i)mkv)$', file):
                list_mkv.append({'filename': file, 'type': 'mkv',
                                'path': '%s%s' % (path, file), 'size': get_size(path, file)})
            else:
                list_other.append({'filename': file, 'type': 'other',
                                  'path': '%s%s' % (path, file), 'size': get_size(path, file)})
        return json.dumps(up + list_folder + list_mp4 + list_mkv + list_other)
    except Exception as e:
        abort(404, str(e))

os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current
# Initialize DataBase
run_sql('''create table if not exists history
                (FILENAME text PRIMARY KEY not null,
                PROGRESS float not null,
                DURATION float, LATEST_DATE datetime not null);''')

if __name__ == '__main__':  # for debug
    os.system('start http://127.0.0.1:8081/')  # open the page automatic
    run(host='0.0.0.0', port=8081, debug=True)  # run demo server
