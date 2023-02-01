FROM public.ecr.aws/lambda/python:3.8

RUN pip install --upgrade pip
RUN pip install boto3

COPY unzip_files.py ./

ENTRYPOINT [ "python", "unzip_files.py" ]
