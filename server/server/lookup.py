import json
import os
from lxml import html
import requests

from server import app
from server import lib
from flask import request

def get_img_url(name):
    google_search = requests.get("https://www.google.com/search?q={}&tbm=isch".format(name))
    tree = html.fromstring(google_search.content)

    # url of first image result on google search
    return tree.xpath('//img')[0].attrib.get('src')

def get_guesses(filename):
    api_results = lib.get_clarifai(filename)

    guesses = []
    print api_results
    for probability in sorted(api_results, reverse=True):
        guess = api_results[probability]
        if len(guesses) == 3:
            return guesses
        if guess != 'no person':
            guesses.append({guess: get_img_url(guess)})

@app.route('/lookup', methods=['POST'])
def lookup():
    filename = request.files['image'].filename

    error_reason = ''

    if 'image' not in request.files:
        error_reason = 'no image'
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file = request.files['image']

    if not file or not lib.allowed_file(filename):
        error_reason = 'not allowed filename'

    if 'language' not in request.form:
        error_reason = 'no language'

    if error_reason:
        print error_reason
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    associations = lib.association_with_translation(request.form['language'],
                                                    get_guesses(filename))

    return json.dumps({'association': associations}), 200
