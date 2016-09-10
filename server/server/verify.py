from server import app
from flask import request

ALLOWED_EXTENSIONS = set(['jpg', 'png'])

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route('/verify', methods=['POST'])
def response():
    error_reason = ''
    error_message = {'error': error_reason }
    if 'file' not in request.files:
        error_reason = 'no file'
        return error_message, 400

    file = request.files['file']

    if not file or not allowed_file(file.filename):
        error_reason = 'not allowed filename'
        return error_message, 400

    if 'name' not in request.files:
        error_reason = 'no name'
        return error_message, 400

    if 'language' not in request.files:
        error_reason = 'no language'
        return error_message, 400

    print "LANGUAGE", request.files['language']
    print "NAME", request.files['name']
    file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

    return { 'associations': [], result: True }
