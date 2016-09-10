import json
import os

from server import app
from server import constants as CONSTANTS
from server import lib
from flask import request

ALLOWED_EXTENSIONS = set(['jpg', 'png'])

KNOWN_WORDS = [key for key in CONSTANTS.ASSOCIATIONS]
print KNOWN_WORDS

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

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
def response():
    filename = request.files['image'].filename

    error_reason = ''

    if 'image' not in request.files:
        error_reason = 'no image'
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file = request.files['image']

    if not file or not allowed_file(filename):
        error_reason = 'not allowed filename'

    if 'name' not in request.form:
        error_reason = 'no name'

    if 'language' not in request.form:
        error_reason = 'no language'

    if error_reason:
        print error_reason
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    if verify_image(filename):
        return json.dumps({'associations': CONSTANTS.ASSOCIATIONS[request.form['name']],
                           'result': True}), 200

    return json.dumps({ 'associations': [], 'result': False }), 200


@app.errorhandler(400)
def badrequest_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 400


@app.errorhandler(Exception)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 500
