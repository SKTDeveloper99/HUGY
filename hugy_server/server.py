from flask import Flask, request, jsonify
from classifier import *

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    return 'Mood predictor version 1.0'

@app.route('/predict/<text>', methods=['GET'])
def predict(text):
    text = request.args.get('text')
    prediction = predict_mood(text)
    return jsonify({'prediction': prediction})

if __name__ == '__main__':
    app.run(debug=True)