#!/usr/bin/env python
# coding=utf-8
"""xlmp unit test"""
import unittest
import json
from tornado.testing import AsyncHTTPTestCase
from xlmp import APP, TRACKER

class TestMain(AsyncHTTPTestCase):
    """test class"""
    def get_app(self):
        return APP

    def test_main(self):
        response = self.fetch('/')
        self.assertEqual(response.code, 200)

    def test_api(self):
        response = self.fetch('/api')
        self.assertEqual(response.code, 405)
        print(response.code)
        print(response.body)


if __name__ == '__main__':
    unittest.main()
