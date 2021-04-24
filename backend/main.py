import os
from flask import Flask
from dotenv import load_dotenv, find_dotenv
from get_secrets import get_secret

load_dotenv(find_dotenv())

app = Flask(__name__)

if __name__ == "__main__":
    app.debug = True

cockroachdb_crt = get_secret(app, "cockroachdb-cc-ca-crt")
if not os.path.exists("cc-ca.crt"):
    with open("cc-ca.crt", "w") as f:
        f.write(cockroachdb_crt)
cockroachdb_url = get_secret(app, "cockroachdb-url")

@app.route("/")
def root():
    return f"Hello, World!\nFirst 10 chars of cert: {cockroachdb_crt[:10]}\nFirst 10 chars of url: {cockroachdb_url[:10]}"

@app.route("/location", methods=['GET'])
def getevent():
    # Get events
    # Args - longitude, latitude, (optional default 5) distance
    return "Hello, World!"

@app.route("/addevent", methods=['POST'])
def getevent():
    # Add a new event
    # Args - longitude, latitude, Animal, Photo, Username
    return "Hello, World!"

@app.route("/getevent", methods=['GET'])
def getevent():
    # Gets an event from UUID
    # Args - Event UUID
    return "Hello, World!"

@app.route("/animal", methods=['POST'])
def getevent():
    # Search for animal and add image to DB
    # Args - Image
    # Returns json - animal name and url of image
    return "Hello, World!"


if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    # Flask's development server will automatically serve static files in
    # the "static" directory. See:
    # http://flask.pocoo.org/docs/1.0/quickstart/#static-files. Once deployed,
    # App Engine itself will serve those files as configured in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)
