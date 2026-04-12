FROM public.ecr.aws/lambda/python:3.10

# Install dependencies
COPY /terraform/modules/lambda/python/requirements.txt .
RUN pip install -r requirements.txt

# Copy app code
COPY terraform/modules/lambda/python/lambda_function.py .

# Set Lambda handler
CMD ["lambda_function.lambda_handler"]