FROM python:alpine3.7
COPY ./src /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 5001
ENTRYPOINT ["python","./main.py"]