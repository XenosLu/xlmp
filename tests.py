#!/usr/bin/env python
# coding=utf-8
"""xlmp unit test"""
import unittest
import json
from tornado.testing import AsyncHTTPTestCase
from xlmp import APP, TRACKER, LOADER

class TestMain(AsyncHTTPTestCase):
    """test class"""
    def get_app(self):
        return APP

    def test_main(self):
        response = self.fetch('/')
        self.assertEqual(response.code, 200)

    def test_main_dlna(self):
        response = self.fetch('/dlna')
        self.assertEqual(response.code, 200)

    def test_fs_ls(self):
        response = self.fetch('/fs/ls/')
        self.assertEqual(response.code, 200)
        self.assertEqual(type(json.loads(response.body.decode())), dict)

    def test_fs_move(self):
        response = self.fetch('/fs/move/test')
        self.assertEqual(response.code, 404)
        # self.assertEqual(response.body, b'Hello, world')

    def test_hist(self):
        response = self.fetch('/hist/ls')
        self.assertEqual(response.code, 200)
        self.assertEqual(type(json.loads(response.body.decode())), dict)
        response = self.fetch('/hist/test')
        self.assertEqual(response.code, 404)

        response = self.fetch('/sys/backup')
        self.assertEqual(response.code, 200)
        response = self.fetch('/hist/clear')
        self.assertEqual(response.code, 200)
        response = self.fetch('/sys/restore')
        self.assertEqual(response.code, 200)
        # response = self.fetch('/hist/rm')

    def test_sys(self):

        response = self.fetch('/sys/test')
        self.assertEqual(response.code, 403)
        print(response.body)
        print('*'*80)
        # response = self.fetch('/hist/clear')
        # response = self.fetch('/hist/rm')




    # (r'/sys/(?P<opt>\w*)', SystemCommandHandler),

    # (r'/dlna/link', DlnaWebSocketHandler),
    # (r'/dlna/info', DlnaInfoHandler),
    # (r'/dlna/setdmr/(?P<dmr>.*)', SetDmrHandler),
    # (r'/dlna/searchdmr', SearchDmrHandler),
    # (r'/dlna/vol/(?P<opt>\w*)', DlnaVolumeControlHandler),
    # (r'/dlna/next', DlnaNextHandler),
    # (r'/dlna/load/(?P<src>.*)', DlnaLoadHandler),
    # (r'/dlna/(?P<opt>\w*)/?(?P<progress>.*)', DlnaHandler),

    # (r'/wp/save/(?P<src>.*)', SaveHandler),
    # (r'/wp/play/(?P<src>.*)', WebPlayerHandler),

if __name__ == '__main__':
    unittest.main()
