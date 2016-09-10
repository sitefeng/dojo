from flask import Flask
app = Flask(__name__)

# index
@app.route("/")
def index():
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