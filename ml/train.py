import pandas as pd
import joblib
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.ensemble import RandomForestClassifier
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

MODEL_DIR = os.path.join(BASE_DIR, "..", "model")

os.makedirs(MODEL_DIR, exist_ok=True)

# Load dataset
df = pd.read_csv(os.path.join(BASE_DIR, "dataset.csv"))

df = pd.read_csv("dataset.csv")

vectorizer = TfidfVectorizer(analyzer='char', ngram_range=(2,4))
X = vectorizer.fit_transform(df["filename"])
y = df["bucket"]

model = RandomForestClassifier(
    n_estimators=200,     # number of trees
    max_depth=None,       # let trees grow fully
    random_state=42,
    n_jobs=-1             # use all CPU cores
)
model.fit(X, y)

joblib.dump(model, "../model/model.pkl")
joblib.dump(vectorizer, "../model/vectorizer.pkl")
