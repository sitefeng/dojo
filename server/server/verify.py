import json
import os

from server import app
from flask import request
from clarifai.client import ClarifaiApi

ALLOWED_EXTENSIONS = set(['jpg', 'png'])

ASSOCIATIONS = {
    'leather': [{'wool': 'http://www.knitrowan.com/files/patterns/Wool%20Cotton%204ply%20505.jpg'},
             {'cotton':'http://www.healthline.com/hlcmsresource/images/topic_centers/EatingDisorders/642x361-4_Ways_the_Cotton_Ball_Diet_Could_Kill_You.jpg'}],
    'technology': [{'internet': 'http://smarterware.org/wp-content/uploads/2016/03/Internet.jpg'},
               {'software': 'https://fiberopticnow.github.io/media/css_code.jpg'}],
    'money': [{'business': 'http://fametutors.com/sitedata/learning_materials/reading_materials/Images/814124162919518522966602653770_22.jpg'},
            {'purchase': 'http://media.graytvinc.com/images/718*404/debit-card-purchase-DO-NOT-USE.jpg'}],
    'drink': [{'eat': 'http://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/articles/health_tools/adhd_feed_your_child_slideshow/getty_rf_photo_of_boy_eating_meatball.jpg'},
            {'snack': 'http://royalwholesalecandy.com/media/catalog/category/snacks_1.jpg'}],
    'fork': [{'spoon': 'http://vignette1.wikia.nocookie.net/tlaststand/images/f/f6/Spoon_IRL.jpg/revision/latest?cb=20150119215557'},
           {'knife': 'https://www.togknives.com/wp-content/uploads/2013/07/TOG-Gyuto-3Quarter-Cutout.jpg'}]
        }

KNOWN_WORDS = [key for key in ASSOCIATIONS]
print KNOWN_WORDS

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def verify_with_clarify(filename):
    clarifai_api = ClarifaiApi()  # assumes environment variables are set.
    result = clarifai_api.tag_images(open('uploads/' + filename, 'rb'))

    api_results = {}
    tag_results = result[u'results'][0][u'result'][u'tag'][u'classes']
    probability_results = result[u'results'][0][u'result'][u'tag'][u'probs']
    for index in enumerate(probability_results):
        probability = round(probability_results[index[0]] * 100)
        tag = str(tag_results[index[0]])

        api_results[probability] = tag

    for probability in (sorted(api_results, reverse=True)):
        print api_results[probability], probability
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

    if verify_with_clarify(filename):
        return json.dumps({'associations': ASSOCIATIONS[request.form['name']],
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
