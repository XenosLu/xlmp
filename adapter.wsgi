import sys
import os
import bottle
sys.path = [os.path.dirname(os.path.abspath(__file__))] + sys.path
os.chdir(os.path.dirname(os.path.abspath(__file__)))
import player  # This loads your application
application = bottle.default_app()
