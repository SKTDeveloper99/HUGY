import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
from nltk.corpus import stopwords
import pickle

from nltk.stem import WordNetLemmatizer
import nltk

def preprocess_text(text):
    lemmatizer = WordNetLemmatizer()
    tokens = nltk.word_tokenize(text.lower())
    stop_words = set(stopwords.words('english'))
    tokens = [lemmatizer.lemmatize(token) for token in tokens if token.isalpha()]
    tokens = [token for token in tokens if token not in stop_words]
    return ' '.join(tokens)

def predict_mood(text):
    processed_text = preprocess_text(text)

    model = pickle.load(open('training/model.pkl', 'rb'))
    classifier = model['classifier']
    vectorizer = model['vectorizer']
    prediction = classifier.predict(vectorizer.transform([processed_text]))
    return prediction[0]

if __name__ == '__main__':
    text = "I am mad today"
    print(predict_mood(text))
