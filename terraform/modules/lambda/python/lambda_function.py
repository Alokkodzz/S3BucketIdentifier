import boto3
import joblib
import os

s3 = boto3.client('s3')

MODEL_BUCKET = "ml-model-bucket-alok"

def download_model():
    if not os.path.exists("/tmp/model.joblib"):
        s3.download_file(MODEL_BUCKET, "model.joblib", "/tmp/model.joblib")
        s3.download_file(MODEL_BUCKET, "vectorizer.joblib", "/tmp/vectorizer.joblib")

download_model()

model = joblib.load('/tmp/model.joblib')
vectorizer = joblib.load('/tmp/vectorizer.joblib')

CONFIDENCE_THRESHOLD = 0.7

def predict_bucket(filename):
    X = vectorizer.transform([filename])
    probs = model.predict_proba(X)[0]
    max_prob = max(probs)
    prediction = model.classes_[probs.argmax()]
    return prediction, max_prob

def lambda_handler(event, context):
    for record in event['Records']:
        key = record['s3']['object']['key']
        source_bucket = record['s3']['bucket']['name']

        bucket, confidence = predict_bucket(key)

        if confidence < CONFIDENCE_THRESHOLD:
            raise Exception("Low confidence")

        copy_source = {'Bucket': source_bucket, 'Key': key}
        s3.copy(copy_source, bucket, key)
        s3.delete_object(Bucket=source_bucket, Key=key)
