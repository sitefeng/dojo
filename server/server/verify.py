import json
import requests
import os

from server import app
from server import constants as CONSTANTS
from server import lib
from flask import request

from pymongo import MongoClient

KNOWN_WORDS = [key for key in CONSTANTS.ASSOCIATIONS]

MONGO = MongoClient()
db = MONGO.prod_app

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def verify_image(filename):
    api_results = lib.get_clarifai(filename)

    for probability in sorted(api_results, reverse=True):
        if api_results[probability] in KNOWN_WORDS:
            if request.form['name'].lower() != api_results[probability].lower():
                return False
            else:
                return True

    return False


@app.route('/words', methods=['GET'])
def words_response():
    lang = request.args.get('language')
    words = request.args.get('list').split(',')

    translated_words = []
    for word in words:
        translated_word = lib.get_translation(word, lang)
        translated_words.append(word)
    return json.dumps({'words': translated_words,
                           'language': lang}), 200


@app.route('/verify', methods=['POST'])
def verify_response():
    print "REQUEST: ", request.__dict__
    print "NAME: ", request.form['name']
    print "LANGUAGE: ", request.form['language']

    print "FILES: ", request.files
    print "FILES DICT: ", request.files.__dict__
    if not request.files['image']:
        print "NO FILE?"

    print "FILE: ", request.files['image']

    filename = request.files['image'].filename
    print "FILENAME: ", filename

    error_reason = ''

    if 'name' not in request.form:
        error_reason = 'no name'

    if 'image' not in request.files:
        error_reason = 'no image'
        error_message = {'error': error_reason}
        print error_reason
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

    dest = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(dest)

    if verify_image(filename):
        guess = request.form['name'].lower()
        if guess in CONSTANTS.ASSOCIATIONS:
            associations = lib.association_with_translation(request.form['language'],
                                                        CONSTANTS.ASSOCIATIONS[guess])
        else:
            associations = []
        db.entries.insert_one(
            {
                'name': request.form['name'],
                'dest': dest,
                'associations': associations,
                'lang': request.form['language']
            }
        )
        return json.dumps({'associations': associations,
                           'result': True}), 200

    return json.dumps({ 'associations': [], 'result': False }), 200
