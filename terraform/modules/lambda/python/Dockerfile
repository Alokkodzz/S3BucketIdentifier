FROM public.ecr.aws/lambda/python:3.13

COPY . .
RUN ls -la

# Install dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy app code
COPY lambda_function.py .

# Set Lambda handler
CMD ["lambda_function.lambda_handler"]