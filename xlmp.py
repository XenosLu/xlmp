#!/usr/bin/python3
# -*- coding:utf-8 -*-
import math
import os
import re
import shutil
import sqlite3
import sys
import logging

from threading import Thread, Event
from urllib.parse import quote, unquote
from time import sleep, time
from concurrent.futures import ThreadPoolExecutor

import tornado.web
import tornado.websocket
import datetime  # test only

os.chdir(os.path.dirname(os.path.abspath(__file__)))  # set file path as current
sys.path = ['lib'] + sys.path  # added libpath
from dlnap import URN_AVTransport_Fmt, discover  # https://github.com/ttopholm/dlnap


VIDEO_PATH = 'media'  # media file path
HISTORY_DB_FILE = '%s/.history.db' % VIDEO_PATH  # history db file


# initialize logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s %(filename)s %(levelname)s [line:%(lineno)d] %(message)s',
                    datefmt='%Y-%m-%d %H:%M:%S')


class DMRTracker(Thread):
    """DLNA Digital Media Renderer tracker thread"""
    def __init__(self, *args, **kwargs):
        super(DMRTracker, self).__init__(*args, **kwargs)
        self._flag = Event()
        self._flag.set()
        self._running = Event()
        self._running.set()
        self.state = {}  # DMR device state
        self.dmr = None  # DMR device object
        self.all_devices = []  # DMR device list
        self._failure = 0
        self._load = None
        logging.info('DMR Tracker initialized.')

    def discover_dmr(self):
        logging.debug('Starting DMR search...')
        if self.dmr:
            logging.info('Current DMR: %s' % self.dmr)
        self.all_devices = discover(name='', ip='', timeout=3,
                                    st=URN_AVTransport_Fmt, ssdp_version=1)
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
        info = self.dmr.info()
        if info:
            self.state['CurrentTransportState'] = info.get('CurrentTransportState')
            return info.get('CurrentTransportState')

    def get_position_info(self):
        position_info = self.dmr.position_info()
        if not position_info:
            return
        for key in ('RelTime', 'TrackDuration'):
            self.state[key] = position_info[key]
        if self.state.get('CurrentTransportState') == 'PLAYING':
            if position_info['TrackURI']:
                self.state['TrackURI'] = unquote(
                    re.sub('http://.*/video/', '', position_info['TrackURI']))
                save_history(self.state['TrackURI'],
                             time_to_second(self.state['RelTime']),
                             time_to_second(self.state['TrackDuration']))
            else:
                logging.info('no Track uri')
        return position_info.get('TrackDuration')

    def run(self):
        while self._running.isSet():
            self._flag.wait()
            if self.dmr:
                self.state['CurrentDMR'] = str(self.dmr)
                self.state['DMRs'] = [str(i) for i in self.all_devices]
                if self.get_transport_state() and not sleep(0.1) and self.get_position_info():
                    if self._failure > 0:
                        logging.info('reset failure count from %d to 0' % self._failure)
                        self._failure = 0
                else:
                    self._failure += 1
                    logging.warning('Losing DMR count: %d' % self._failure)
                    if self._failure >= 3:
                        logging.info('No DMR currently.')
                        self.state = {}
                        self.dmr = None
                sleep(0.8)
            else:
                self.discover_dmr()
                sleep(2.5)

    def pause(self):
        self._flag.clear()

    def resume(self):
        self._flag.set()

    def stop(self):
        self._flag.set()
        self._running.clear()

    def loadonce(self, url):
        try:
            while self.get_transport_state() not in ('STOPPED', 'NO_MEDIA_PRESENT'):
                self.dmr.stop()
                logging.info('Waiting for DMR stopped...')
                sleep(0.85)
            if self.dmr.set_current_media(url):
                logging.info('Loaded %s' % url)
            else:
                logging.warning('Load url failed: %s' % url)
                return False
            time0 = time()
            while self.get_transport_state() not in ('PLAYING', 'TRANSITIONING'):
                self.dmr.play()
                logging.info('Waiting for DMR playing...')
                sleep(0.3)
                if (time() - time0) > 5:
                    logging.info('waiting for DMR playing timeout')
                    return False
            sleep(0.5)
            time0 = time()
            logging.info('checking duration to make sure loaded...')
            while self.dmr.position_info().get('TrackDuration') == '00:00:00':
                sleep(0.5)
                logging.info('Waiting for duration to be recognized correctly, url=%s' % url)
                if (time() - time0) > 9:
                    logging.info('Load duration timeout')
                    return False
            logging.info(self.state)
        except Exception as e:
            logging.warning('DLNA load exception: %s' % e, exc_info=True)
            return False
        return True


class DLNALoader(Thread):
    """Load url through DLNA"""
    def __init__(self, *args, **kwargs):
        super(DLNALoader, self).__init__(*args, **kwargs)
        self._running = Event()
        self._running.set()
        self._flag = Event()
        self._failure = 0
        self._url = ''
        logging.info('DLNA URL loader initialized.')

    def run(self):
        while self._running.isSet():
            self._flag.wait()
            tracker.pause()
            sleep(0.5)
            url = self._url
            if tracker.loadonce(url):
                logging.info('Loaded url: %s successed' % url)
                src = unquote(re.sub('http://.*/video/', '', url))
                position = hist_load(src)
                if position:
                    tracker.dmr.seek(second_to_time(position))
                    logging.info('Loaded position: %s' % second_to_time(position))
                logging.info('Load Successed.')
                tracker.state['CurrentTransportState'] = 'Load Successed.'
                if url == self._url:
                    self._flag.clear()
            else:
                self._failure += 1
                if self._failure >= 3:
                    self._flag.clear()
            tracker.resume()
            logging.info('tracker resume')

    def stop(self):
        self._flag.set()
        self._running.clear()

    def load(self, url):
        self._url = url
        self._failure = 0
        self._flag.set()


def run_sql(sql, *args):
    with sqlite3.connect(HISTORY_DB_FILE) as conn:
        try:
            cursor = conn.execute(sql, args)
            ret = cursor.fetchall()
            cursor.close()
            if cursor.rowcount > 0:
                conn.commit()
        except Exception as e:
            logging.warning(str(e))
            ret = ()
    return ret


def ls_dir(path):
    if path == '/':
        path = ''
    up, list_folder, list_mp4, list_video, list_other = [], [], [], [], []
    if path:
        up = [{'filename': '..', 'type': 'folder', 'path': '%s..' % path}]  # path should be path/
        if not path.endswith('/'):
            path = '%s/' % path
    dir_list = sorted(os.listdir('%s/%s' % (VIDEO_PATH, path)))  # path could be either path or path/
    for filename in dir_list:
        if filename.startswith('.'):
            continue
        if os.path.isdir('%s/%s%s' % (VIDEO_PATH, path, filename)):
            list_folder.append({'filename': filename, 'type': 'folder',
                                'path': '%s%s' % (path, filename)})
        elif re.match('.*\.((?i)mp)4$', filename):
            list_mp4.append({'filename': filename, 'type': 'mp4',
                            'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
        elif re.match('.*\.((?i)(mkv|avi|flv|rmvb|wmv))$', filename):
            list_video.append({'filename': filename, 'type': 'video',
                               'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
        else:
            list_other.append({'filename': filename, 'type': 'other',
                              'path': '%s%s' % (path, filename), 'size': get_size(path, filename)})
    return ({'filesystem': (up + list_folder + list_mp4 + list_video + list_other)})


def second_to_time(second):
    """ Turn time in seconds into "hh:mm:ss" format

    second: int value
    """
    m, s = divmod(second, 60)
    h, m = divmod(second/60, 60)
    return '%02d:%02d:%06.3f' % (h, m, s)


def time_to_second(time_str):
    """ Turn time in "hh:mm:ss" format into seconds

    time_str: string like "hh:mm:ss"
    """
    return sum([float(i)*60**n for n, i in enumerate(str(time_str).split(':')[::-1])])


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


def hist_load(name):
    position = run_sql('select POSITION from history where FILENAME=?', name)
    if len(position) == 0:
        return 0
    return position[0][0]


def save_history(src, position, duration):
    if float(position) < 10:
        return
    run_sql('''replace into history (FILENAME, POSITION, DURATION, LATEST_DATE)
               values(? , ?, ?, DateTime('now', 'localtime'));''', src, position, duration)


def check_dmr_exist(func):
    def no_dmr(self, *args, **kwargs):
        if not tracker.dmr:
            # return 'Error: No DMR.'
            self.finish('Error: No DMR.')
            return
        return func(self, *args, **kwargs)
    return no_dmr


def get_next_file(src):
    fullname = '%s/%s' % (VIDEO_PATH, src)
    filepath = os.path.dirname(fullname)
    dirs = sorted([i for i in os.listdir(filepath)
                   if not i.startswith('.') and os.path.isfile('%s/%s' % (filepath, i))])
    next_index = dirs.index(os.path.basename(fullname)) + 1
    if next_index < len(dirs):
        return '%s/%s' % (os.path.dirname(src), dirs[next_index])


class IndexHandler(tornado.web.RequestHandler):
    def get(self):
        if tracker.dmr:
            dlna_style = 'btn-success'
        else:
            dlna_style = ''
        self.render('index.tpl', dlna_style=dlna_style)


class DlnaPlayerHandler(tornado.web.RequestHandler):
    def get(self):
        if tracker.dmr:
            dlna_style = 'btn-success'
        else:
            dlna_style = ''
        self.render('dlna_player.tpl', dlna_style=dlna_style)


class WebPlayerHandler(tornado.web.RequestHandler):
    """Video play page"""
    def get(self, src):
        if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
            self.redirect('/')
        self.render('player.tpl', dlna_style='', src=src, position=hist_load(src))


class HistoryHandler(tornado.web.RequestHandler):
    """Return play history list"""
    def get(self, opt='ls', src=None):
        if opt == 'ls':
            pass
        elif opt == 'clear':
            run_sql('delete from history')
        elif opt == 'rm':
            run_sql('delete from history where FILENAME=?', unquote(src))
        else:
            raise tornado.web.HTTPError(404)
        self.finish({'history': [{'filename': s[0], 'position': s[1], 'duration': s[2],
                        'latest_date': s[3], 'path': os.path.dirname(s[0])}
                       for s in run_sql('select * from history order by LATEST_DATE desc')]})


class FileSystemListHandler(tornado.web.RequestHandler):
    """Get static folder list in json"""
    def get(self, path):
        try:
            self.finish(ls_dir(path))
        except Exception as e:
            raise tornado.web.HTTPError(404, reason=str(e))


class FileSystemMoveHandler(tornado.web.RequestHandler):
    """Move file to '.old' folder"""
    def get(self, src):
        filename = '%s/%s' % (VIDEO_PATH, src)
        dir_old = '%s/%s/.old' % (VIDEO_PATH, os.path.dirname(src))
        if not os.path.exists(dir_old):
            os.mkdir(dir_old)
        try:
            shutil.move(filename, dir_old)  # gonna do something when file is occupied
        except Exception as e:
            logging.warning('move file failed: %s' % e)
            raise tornado.web.HTTPError(404, reason=str(e))
            # raise tornado.web.HTTPError(404)
        self.finish(ls_dir('%s/' % os.path.dirname(src)))


class SaveHandler(tornado.web.RequestHandler):
    """Save play history"""
    executor = ThreadPoolExecutor(9)
    @tornado.gen.coroutine
    @tornado.concurrent.run_on_executor
    def post(self, src):
        position = self.get_argument('position', 0)
        duration = self.get_argument('duration', 0)
        save_history(src, position, duration)


class DlnaLoadHandler(tornado.web.RequestHandler):
    @check_dmr_exist
    def get(self, src):
        if not os.path.exists('%s/%s' % (VIDEO_PATH, src)):
            logging.warning('File not found: %s' % src)
            self.finish('Error: File not found.')
            return
        logging.info('start loading... tracker state:%s' % tracker.state.get('CurrentTransportState'))
        url = 'http://%s/video/%s' % (self.request.headers['Host'], quote(src))
        loader.load(url)
        self.finish('loading %s' % src)


class DlnaNextHandler(tornado.web.RequestHandler):
    @check_dmr_exist
    def get(self):
        if not tracker.state.get('TrackURI'):
            self.finish('No current url')
            return
        next_file = get_next_file(tracker.state['TrackURI'])
        logging.info('next file recognized: %s' % next_file)
        if next_file:
            url = 'http://%s/video/%s' % (self.request.headers['Host'], quote(next_file))
            loader.load(url)
            # dlna_load(next_file)
        else:
            self.finish("Can't get next file")


class DlnaHandler(tornado.web.RequestHandler):
    @check_dmr_exist
    def get(self, opt, *args, **kw):
        self.write('opt: %s' % opt)
        method = getattr(tracker.dmr, opt)
        if opt in ('play', 'pause', 'stop'):
            ret = method()
        elif opt == 'seek':
            ret = method(*kw.values())
        else:
            return
        # self.write(str(method))
        if ret:
        # if method():
            self.finish('Done.')
        else:
            self.finish('Error: Failed!')


class DlnaInfoHandler(tornado.web.RequestHandler):
    def get(self):
        self.finish(tracker.state)


class DlnaVolumeControlHandler(tornado.web.RequestHandler):
    """Tune volume through DLNA"""
    @check_dmr_exist
    def get(self, opt):
        vol = int(tracker.dmr.get_volume())
        if opt == 'up':
            vol += 1
        elif opt == 'down':
            vol -= 1
        if not 0 <= vol <= 100:
            self.finish('volume range exceeded')
        elif tracker.dmr.volume(vol):
            self.finish(str(vol))
        else:
            self.finish('failed')


class SystemHandler(tornado.web.RequestHandler):
    def get(self, opt=None):
        if sys.platform == 'linux':
            if os.system('git pull') == 0:
                self.finish('git pull done, waiting for restart')
                os._exit(1)
            else:
                self.finish('execute git pull failed')
        else:
            self.finish('not supported')


class SetDmrHandler(tornado.web.RequestHandler):
    def get(self, dmr):
        if tracker.set_dmr(dmr):
            self.finish('Done.')
        else:
            self.finish('Error: Failed!')


class SearchDmrHandler(tornado.web.RequestHandler):
    def get(self):
        tracker.discover_dmr()


class TestHandler(tornado.web.RequestHandler):
    def get(self):
        self.finish('1')


class DlnaWebSocketHandler(tornado.websocket.WebSocketHandler):
    executor = ThreadPoolExecutor(9)
    _running = False
    @tornado.gen.coroutine
    @tornado.concurrent.run_on_executor
    def open(self):
        self._running = True
        last_message = ''
        # n = 0  # test
        while self._running:
            # n += 1  # test
            # logging.info(self.executor._work_queue.unfinished_tasks)
            if last_message != tracker.state:
                self.write_message(tracker.state)
                logging.info(tracker.state.get('RelTime'))
                last_message = tracker.state.copy()
            # self.write_message({"RelTime":"00:22:%d" % n})  # test
            sleep(0.2)

    def on_message(self, message):
        logging.info('receive: %s' % message)

    def on_close(self):
        logging.info('ws close: %s' % self.request.remote_ip)
        self._running = False

Handlers=[
    (r'/', IndexHandler),
    (r'/dlna', DlnaPlayerHandler),
    (r'/fs/(?P<path>.*)', FileSystemListHandler),
    (r'/move/(?P<src>.*)', FileSystemMoveHandler),
    (r'/hist/(?P<opt>\w*)/?(?P<src>.*)', HistoryHandler),
    (r'/test/?', TestHandler),
    (r'/dlnalink', DlnaWebSocketHandler),
    (r'/setdmr/(?P<dmr>.*)', SetDmrHandler),
    (r'/searchdmr', SearchDmrHandler),
    (r'/sys/update', SystemHandler),
    (r'/dlnavol/(?P<opt>\w*)', DlnaVolumeControlHandler),
    (r'/dlnainfo', DlnaInfoHandler),
    (r'/dlna/next', DlnaNextHandler),
    (r'/dlna/load/(?P<src>.*)', DlnaLoadHandler),
    (r'/dlna/(?P<opt>\w*)/?(?P<args>\w*)', DlnaHandler),
    (r'/save/(?P<src>.*)', SaveHandler),
    (r'/play/(?P<src>.*)', WebPlayerHandler),
    (r'/video/(.*)', tornado.web.StaticFileHandler, {'path': VIDEO_PATH})
]

settings = {
    'static_path': 'static',
    'template_path': 'views',
    'gzip': True,
    # "debug": True,
}
application = tornado.web.Application(Handlers, **settings)
# initialize DataBase
run_sql('''create table if not exists history
                (FILENAME text PRIMARY KEY not null,
                POSITION float not null,
                DURATION float, LATEST_DATE datetime not null);''')
# initialize dlna threader
tracker = DMRTracker()
tracker.start()
loader = DLNALoader()
loader.start()


if __name__ == "__main__":
    if sys.platform == 'win32':
        os.system('start http://127.0.0.1:8888/')
    application.listen(8888)
    tornado.ioloop.IOLoop.instance().start()


# @post('/suspend')
# def suspend():
    # """Suepend server"""
    # if sys.platform == 'win32':
        # import ctypes
        # dll = ctypes.WinDLL('powrprof.dll')
        # if dll.SetSuspendState(0, 1, 0):
            # return 'Suspending...'
        # else:
            # return 'Suspend Failure!'
    # else:
        # return 'OS not supported!'


# @post('/shutdown')
# def shutdown():
    # """Shutdown server"""
    # if sys.platform == 'win32':
        # os.system("shutdown.exe -f -s -t 0")
    # else:
        # os.system("sudo /sbin/shutdown -h now")
    # return 'shutting down...'


@route('/backup')
def sys_backup():
    """backup history"""
    return shutil.copyfile(HISTORY_DB_FILE, '%s.bak' % HISTORY_DB_FILE)


@route('/restore')
def sys_restore():
    """restore history"""
    return shutil.copyfile('%s.bak' % HISTORY_DB_FILE, HISTORY_DB_FILE)
