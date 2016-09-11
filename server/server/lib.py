from clarifai.client import ClarifaiApi
import requests
import json

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

def get_translation(source_text, dest_lang):
    link = "https://www.googleapis.com/language/translate/v2?q=" + source_text + "&target=" + dest_lang + "&key=AIzaSyAEq1snggjJn11nZ3-BZzdToUcKdYG5y60"
    response_body = requests.get(link).content

    translated_word = json.loads(response_body)[u'data'][u'translations'][0][u'translatedText']
    return translated_word

def association_with_translation(lang, associations):
    final_associations = []
    for obj in associations:
        for assoc_name in obj:
            association = {'name': assoc_name, 'url': obj[assoc_name],
                           'translation': get_translation(assoc_name, lang)}
            final_associations.append(association)

    return final_associations
