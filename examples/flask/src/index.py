from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return { "message": "hello" }

@app.route("/count")
def hello():
    return {"visit_count" : 1}


@app.route("/health")
def status():
    return {"healthy": True}


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("5001"), debug=True)
