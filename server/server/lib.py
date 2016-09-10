from clarifai.client import ClarifaiApi

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
