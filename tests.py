#!/usr/bin/env python
# coding=utf-8
"""xlmp unit test"""
import unittest
import json
from tornado.testing import AsyncHTTPTestCase
from xlmp import APP

class TestMain(AsyncHTTPTestCase):
    """test class"""
    def get_app(self):
        return APP

    def test_main(self):
        """test main page"""
        response = self.fetch('/')
        self.assertEqual(response.code, 200)

    def test_playtoggle(self):
        """test dlna playtoggle interface"""
        response = self.fetch('/playtoggle')
        self.assertEqual(response.code, 200)

    def test_api(self):
        """test json rpc web api"""
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

        response = self.fetch('/api', method="POST", body='{"jsonrpc":"2.0", "method":"test"}')
        self.assertEqual(response.code, 200)
        self.assertEqual(response.body, b'')  # Notification

        response = self.fetch(
            '/api', method="POST", body='{"jsonrpc":"2.0", "method":"test", "id": 1}')
        self.assertEqual(response.code, 200)
        self.assertEqual(json.loads(response.body)['result'], 'test message')  # Success

if __name__ == '__main__':
    unittest.main()
