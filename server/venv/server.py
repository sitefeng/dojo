import pprint

from flask import Flask
from clarifai.client import ClarifaiApi
app = Flask(__name__)


# index
@app.route("/")
def index():
	clarifai_api = ClarifaiApi() # assumes environment variables are set.
	result = clarifai_api.tag_images(open('green_can2.jpg', 'rb'))

	# pp = pprint.PrettyPrinter(indent = 4)
	# pp.pprint(result)

	clarifai_results = {}
	tag_results = result[u'results'][0][u'result'][u'tag'][u'classes']
	probability_results = result[u'results'][0][u'result'][u'tag'][u'probs']
	for index in enumerate(tag_results):
		probability = round(probability_results[index[0]] * 100)
		tag = str(tag_results[index[0]])
		
		clarifai_results[probability] = tag

	results = []
	for probability in (sorted(clarifai_results, reverse = True)):
		results.append((clarifai_results[probability], probability))
	
	print results

	return "o hai."

# endpoint for receiving inbound messages
@app.route("/messages")
def get_messages():
	return "receiving messages..."

# endpoint for confirming message delivery
@app.route("/confirm")
def confirm():
	return "this is a confirmation"

if __name__ == "__main__":
    app.run()