from flask import Flask, request, jsonify
from classifier import *

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return 'Mood predictor version 1.0'

#post method
@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json(force=True)
    text = data['text']
    prediction = predict_mood(text)
    return jsonify(prediction)


if __name__ == '__main__':
    app.run(debug=True)