FROM public.ecr.aws/lambda/python:3.10

RUN ls -la

# Install dependencies
COPY S3BucketIdentifier/terraform/modules/lambda/python/requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY S3BucketIdentifier/terraform/modules/lambda/python/lambda_function.py .

# Set Lambda handler
CMD ["lambda_function.lambda_handler"]