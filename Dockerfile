FROM python:3.10-slim

WORKDIR /app

COPY . /app

RUN pip install flask

EXPOSE 3000

CMD ["python3", "app.py"]
