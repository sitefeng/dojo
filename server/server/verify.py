from server import app
import json
import os
from flask import request

ALLOWED_EXTENSIONS = set(['jpg', 'png'])

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/verify', methods=['POST'])
def response():
    print request.files['image'].filename
    print request.form['name']
    # see all the keys
    #print request.__dict__

    error_reason = ''

    if 'image' not in request.files:
        error_reason = 'no image'
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file = request.files['image']

    if not file or not allowed_file(file.filename):
        error_reason = 'not allowed filename'

    if 'name' not in request.form:
        error_reason = 'no name'

    if 'language' not in request.form:
        error_reason = 'no language'

    if error_reason:
        print error_reason
        error_message = {'error': error_reason}
        return json.dumps(error_message), 400

    file.save(os.path.join(app.config['UPLOAD_FOLDER'], file.filename))

    return json.dumps({ 'associations': [], 'result': True }), 200

@app.errorhandler(400)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 400

@app.errorhandler(Exception)
def unhandled_exception(e):
    app.logger.error('Unhandled Exception: %s', (e))
    return json.dumps({'error': e}), 500
