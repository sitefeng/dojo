from clarifai.client import ClarifaiApi

ALLOWED_EXTENSIONS = set(['jpg', 'png'])

def get_clarifai(filename):
    clarifai_api = ClarifaiApi()  # assumes environment variables are set.
    result = clarifai_api.tag_images(open('uploads/' + filename, 'rb'))

    api_results = {}
    tag_results = result[u'results'][0][u'result'][u'tag'][u'classes']
    probability_results = result[u'results'][0][u'result'][u'tag'][u'probs']
    for index in enumerate(probability_results):
        probability = round(probability_results[index[0]] * 100)
        tag = str(tag_results[index[0]])

        api_results[probability] = tag

    return api_results

def allowed_file(filename):
    return '.' in filename and \
            filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
