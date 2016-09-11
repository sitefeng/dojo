import json
import os

from server import app
from server import constants as CONSTANTS
from server import lib
from flask import request

from pymongo import MongoClient

KNOWN_WORDS = [key for key in CONSTANTS.ASSOCIATIONS]

MONGO = MongoClient()

def verify_image(filename):
    api_results = lib.get_clarifai(filename)

    print api_results
    for probability in sorted(api_results, reverse=True):
        print probability
        if api_results[probability] in KNOWN_WORDS:
            if request.form['name'] != api_results[probability]:
                return False
            else:
                return True

    return False

@app.route('/verify', methods=['POST'])
def verify():
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
        db = MONGO.prod_app
        db.entries.insert_one(
            {
                'name': request.form['name'],
                'dest': dest,
                'associations': CONSTANTS.ASSOCIATIONS[request.form['name']]
            }
        )
        return json.dumps({'associations': CONSTANTS.ASSOCIATIONS[request.form['name']],
                           'result': True}), 200

    return json.dumps({ 'associations': [], 'result': False }), 200
