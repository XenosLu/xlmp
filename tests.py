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

        response = self.fetch('/api', method="POST", body='')
        self.assertEqual(response.code, 200)
        self.assertEqual(json.loads(response.body)['error']['code'], -32700)  # Parse error

        response = self.fetch('/api', method="POST", body='"x"')
        self.assertEqual(response.code, 200)
        self.assertEqual(json.loads(response.body)['error']['code'], -32600)  # Invalid Request

        response = self.fetch('/api', method="POST", body='{"jsonrpc":"2.0"}')
        self.assertEqual(response.code, 200)
        self.assertEqual(json.loads(response.body)['error']['code'], -32601)  # Invalid params

# id	8512
# jsonrpc	2.0
# method	test
if __name__ == '__main__':
    unittest.main()
