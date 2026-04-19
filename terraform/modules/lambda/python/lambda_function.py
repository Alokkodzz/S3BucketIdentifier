import boto3
import joblib
import os
import json

s3 = boto3.client('s3')

MODEL_BUCKET = "ml-model-bucket-alok"

def download_model():
    if not os.path.exists("/tmp/model.joblib"):
        s3.download_file(MODEL_BUCKET, "model.joblib", "/tmp/model.joblib")
        s3.download_file(MODEL_BUCKET, "vectorizer.joblib", "/tmp/vectorizer.joblib")

download_model()

model = joblib.load('/tmp/model.joblib')
vectorizer = joblib.load('/tmp/vectorizer.joblib')

CONFIDENCE_THRESHOLD = 0.1

def predict_bucket(filename):
    X = vectorizer.transform([filename])
    probs = model.predict_proba(X)[0]
    max_prob = max(probs)
    prediction = model.classes_[probs.argmax()]
    return prediction, max_prob

def lambda_handler(event, context):
    for record in event['Records']:

        #Step 1: Read SQS message body
        body = json.loads(record['body'])

        #Step 2: Extract actual S3 event from body
        s3_event = body['Records'][0]

        key = s3_event['s3']['object']['key']
        source_bucket = s3_event['s3']['bucket']['name']

        print(f"Processing file: {key} from {source_bucket}")

        bucket, confidence = predict_bucket(key)

        print(f"Predicted bucket: {bucket}, confidence: {confidence}")

        if confidence < CONFIDENCE_THRESHOLD:
            raise Exception("Low confidence")

        copy_source = {'Bucket': source_bucket, 'Key': key}

        #Step 3: Copy + delete
        s3.copy(copy_source, bucket, key)
        s3.delete_object(Bucket=source_bucket, Key=key)