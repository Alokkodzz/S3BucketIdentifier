import pandas as pd
import joblib
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression

df = pd.read_csv("dataset.csv")

vectorizer = TfidfVectorizer(analyzer='char', ngram_range=(2,4))
X = vectorizer.fit_transform(df["filename"])
y = df["bucket"]

model = LogisticRegression(max_iter=200)
model.fit(X, y)

joblib.dump(model, "../lambda/model.joblib")
joblib.dump(vectorizer, "../lambda/vectorizer.joblib")
