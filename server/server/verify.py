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
            if request.form['name'] != api_results[probability]:
                return False
            else:
                return True

    return False

def get_translation(source_text, dest_lang):
    link = "https://www.googleapis.com/language/translate/v2?q=" + source_text + "&target=" + dest_lang + "&key=AIzaSyAEq1snggjJn11nZ3-BZzdToUcKdYG5y60"
    response_body = requests.get(link).content
    translated_word = json.loads(response_body)[u'data'][u'translations'][0][u'translatedText']
    return translated_word


@app.route('/words', methods=['GET'])
def words_response():
    lang = request.args.get('language')
    words = request.args.get('list').split(',')

    translated_words = []
    for word in words:
        translated_word = get_translation(word, lang)
        translated_words.append(translated_word)
    return json.dumps({'words': translated_words,
                           'language': lang}), 200


@app.route('/verify', methods=['POST'])
def verify_response():
    filename = request.files['image'].filename

    error_reason = ''

    if 'name' not in request.form:
        error_reason = 'no name'

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

    dest = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file.save(dest)

    if verify_image(filename):
        associations = get_translated_associations(request)
        db.entries.insert_one(
            {
                'name': request.form['name'],
                'dest': dest,
                'associations': associations
            }
        )
        return json.dumps({'associations': associations,
                           'result': True}), 200

    return json.dumps({ 'associations': [], 'result': False }), 200


def get_translated_associations(request):
    print request
    translations = []
    associations = CONSTANTS.ASSOCIATIONS[request.form['name']]
    for association in associations:
        for pair in association:
            translated_word = get_translation(pair, request.form['language'])
            pairing = {}
            pairing[translated_word] = association[pair]
            translations.append(pairing)
    return translations


@app.errorhandler(400)
def badrequest_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 400


@app.errorhandler(Exception)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 500
