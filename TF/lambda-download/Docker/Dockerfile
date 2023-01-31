FROM public.ecr.aws/lambda/python:3.8

RUN pip install --upgrade pip
RUN pip install boto3

COPY lambda_function.py ./

CMD [ "lambda_function.lambda_handler" ]
