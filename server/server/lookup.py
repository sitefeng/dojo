import json
import os
from lxml import html
import requests

from server import app
from flask import request

def get_img_url(name):
    google_search = requests.get("https://www.google.com/search?q={}&tbm=isch".format(name))
    tree = html.fromstring(google_search.content)
    # url of first image result on google search
    return tree.xpath('//img')[0].attrib.get('src')
