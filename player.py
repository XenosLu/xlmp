#!/usr/bin/python3
# -*- coding:utf-8 -*-
import os
import sys
import shutil
import sqlite3
import math
import json
import re

from bottle import route, post, template, static_file, abort, request, redirect, run  # pip install bottle  # 1.2

MP4_PATH = './static/mp4'  # mp4 file path


def run_sql(sql, *args):
    conn = sqlite3.connect('player.db')  # define DB connection
    try:
        cursor = conn.execute(sql, args)
        result = cursor.fetchall()
        cursor.close()
        if cursor.rowcount > 0:
            conn.commit()
    except Exception as e:
        print(str(e))
        result = []
    finally:
        conn.close()
    return result


def get_size(filename):
    size = os.path.getsize('%s/%s' % (MP4_PATH, filename))
    if size < 0:
        return 'Out of Range'
    if size < 1024:
        return '%dB' % size
    else:
        unit = ['B', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB', 'BB']
        l = min(int(math.floor(math.log(size, 1024))), 9)
        return '%.1f%s' % (size/1024.0**l, unit[l])


def load_history(name):
    progress = run_sql('select PROGRESS from history where FILENAME=?', name)
    if len(progress) == 0:
        return 0
    return progress[0][0]


@route('/list')
def list_history():
    """Return play history list"""
    return json.dumps([{'filename': s[0], 'progress': s[1], 'duration': s[2], 'latest_date': s[3], 
                        'path': os.path.dirname(s[0])}
                       for s in run_sql('select * from history order by LATEST_DATE desc')])


@route('/')
def index():
    return template('player', src='', progress=0, title='Light mp4 Player')


@route('/play/<src:re:.*\.((?i)mp)4$>')
def play(src):
    """Video play page"""
    if not os.path.exists('%s/%s' % (MP4_PATH, src)):
        redirect('/')
    return template('player', src=src, progress=load_history(src), title=src)


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
    file = '%s/%s' % (MP4_PATH, src)
    dir_old = '%s/%s/old' % (MP4_PATH, os.path.dirname(src))
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
    # src = request.query.src
    # progress = request.GET.get('progress')
    # duration = request.GET.get('duration')
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


@route('/mp4/<filename:re:.*\.((?i)mp)4$>')
def static_mp4(filename):
    """mp4 file access
       To support large file(>2GB), you should use web server to deal with static files.
       Such as Apache, use "AliasMatch"
    """
    return static_file(filename, root=MP4_PATH)


@route('/fs/<path:re:.*>')
def fs_dir(path):
    """Get static folder list in json"""
    try:
        fs_list, fs_list_folder, fs_list_mp4, fs_list_other = [], [], [], []
        if path != '':
            fs_list.append({'type': 'folder', 'path': '/%s..' % path, 'filename': '..'})
        for file in os.listdir('%s/%s' % (MP4_PATH, path)):
            if os.path.isdir('%s/%s%s' % (MP4_PATH, path, file)):
                fs_list_folder.append({'filename': file, 'type': 'folder', 'path': '/%s%s' % (path, file)})
            elif re.match('.*\.((?i)mp)4$', file):
                fs_list_mp4.append({'filename': file, 'type': 'mp4',
                                    'path': '%s%s' % (path, file), 'size': get_size(path + file)})
            else:
                fs_list_other.append({'filename': file, 'type': 'other',
                                      'path': '%s%s' % (path, file), 'size': get_size(path + file)})
        return json.dumps(fs_list + fs_list_folder+fs_list_mp4+fs_list_other)
    except Exception as e:
        abort(404, str(e))


    # if path != '':
        # dirs = path.split('/')
        # html_dir = '''
        # <tr><td colspan=3>
        # <ol class="breadcrumb">
          # <li>
            # <span class="filelist folder">
              # <i class="glyphicon glyphicon-home" title="/"></i>
            # </span>
          # </li>
          # '''
        # for n, i in enumerate(dirs[:-1:], 1):
            # print("/%s %s" % ('/'.join(dirs[0:n]), i))
            # html_dir += '''
            # <li><span class="filelist folder" title="/%s">%s</span>
            # </li>''' % ('/'.join(dirs[0:n]), i)
        # html_dir += '''
          # <li class="active">%s</li>
        # </ol>
        # </td></tr>''' % dirs[-1]
        # path = '%s/' % path.strip('/')

os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current
# Initialize DataBase
run_sql('''create table if not exists history
                (FILENAME text PRIMARY KEY not null,
                PROGRESS float not null,
                DURATION float, LATEST_DATE datetime not null);''')

if __name__ == '__main__':  # for debug
    os.system('start http://127.0.0.1:8081/')  # open the page automatic
    run(host='0.0.0.0', port=8081, debug=True)  # run demo server
