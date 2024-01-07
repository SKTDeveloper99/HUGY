import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.svm import LinearSVC
from sklearn.metrics import classification_report
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

# Load the dataset
train_data = pd.read_csv('dataset/train.txt', sep=';', header=None, names=['sentence', 'emotion'])
test_data = pd.read_csv('dataset/test.txt', sep=';', header=None, names=['sentence', 'emotion'])

# Preprocess the text data
nltk.download('stopwords')
nltk.download('wordnet')
stop_words = set(stopwords.words('english'))
lemmatizer = WordNetLemmatizer()

def preprocess_text(text):
    tokens = nltk.word_tokenize(text.lower())
    tokens = [lemmatizer.lemmatize(token) for token in tokens if token.isalpha()]
    tokens = [token for token in tokens if token not in stop_words]
    return ' '.join(tokens)

train_data['preprocessed_sentence'] = train_data['sentence'].apply(preprocess_text)
test_data['preprocessed_sentence'] = test_data['sentence'].apply(preprocess_text)

# Create feature vectors using TF-IDF
vectorizer = TfidfVectorizer()
X_train = vectorizer.fit_transform(train_data['preprocessed_sentence'])
X_test = vectorizer.transform(test_data['preprocessed_sentence'])

# Split the data into training and testing sets
y_train = train_data['emotion']
y_test = test_data['emotion']

# Train a LinearSVC classifier
classifier = LinearSVC()
classifier.fit(X_train, y_train)

# Make predictions on the test set
y_pred = classifier.predict(X_test)

# Evaluate the model
print(classification_report(y_test, y_pred))

# Save the model
import pickle

model = {
    'classifier': classifier,
    'vectorizer': vectorizer
}

pickle.dump(model, open('model.pkl', 'wb'))

if __name__ == '__main__':
    # test the model
    text = "I am mad today"
    text = preprocess_text(text)
    text_vector = vectorizer.transform([text])
    print(classifier.predict(text_vector))

