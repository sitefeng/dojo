import json
import os

from server import app
from flask import request
from clarifai.client import ClarifaiApi

ALLOWED_EXTENSIONS = set(['jpg', 'png'])


def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


def validate_request(request, filename):
    error_reason = ''

    if 'image' not in request.files:
        error_reason = 'no image'
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

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


def verify_with_clarify(filename):
    clarifai_api = ClarifaiApi()  # assumes environment variables are set.
    result = clarifai_api.tag_images(open('uploads/' + filename, 'rb'))

    api_results = {}
    tag_results = result[u'results'][0][u'result'][u'tag'][u'classes']
    probability_results = result[u'results'][0][u'result'][u'tag'][u'probs']
    for index in enumerate(probability_results):
        probability = round(probability_results[index[0]] * 100)
        tag = str(tag_results[index[0]])

        api_results[tag] = probability

    # results = {}
    # for probability in (sorted(clarifai_results, reverse = True)):
    #     results[clarifai_results[probability]] = probability

    if request.form['name'] in api_results:
        return True
    else:
        return False


@app.route('/verify', methods=['POST'])
def response():
    filename = request.files['image'].filename

    validate_request(request, filename)
    verification = verify_with_clarify(filename)

    return json.dumps({ 'associations': [], 'result': verification }), 200


@app.errorhandler(400)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 400


@app.errorhandler(Exception)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 500
