#!/usr/bin/python3
# -*- coding:utf-8 -*-
import sys
import os
from bottle import default_app
sys.path = [os.path.dirname(os.path.abspath(__file__))] + sys.path
os.chdir(os.path.dirname(os.path.abspath(__file__)))
import xlmp  # This loads your application
application = default_app()
