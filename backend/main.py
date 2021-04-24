import json

from flask.wrappers import Response
import config

if __name__ == "__main__":
    config.DEBUG = True

from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())


import os

from flask.json import jsonify, JSONEncoder
from flask import Flask, request

from get_secrets import get_secret
from sql import engine, AnimalSighting
from sqlalchemy import select
from sqlalchemy.orm import Session

from google.cloud import storage, vision

from blake3 import blake3

import datetime

app = Flask(__name__)


class CustomJSONEncoder(JSONEncoder):
    "Add support for serializing timedeltas"

    def default(self, o):
        if type(o) == datetime.timedelta:
            return str(o)
        elif type(o) == datetime.datetime:
            return o.isoformat()
        else:
            return super().default(o)


app.json_encoder = CustomJSONEncoder


cockroachdb_crt = get_secret("cockroachdb-cc-ca-crt")
# if not os.path.exists("cc-ca.crt"):
#     with open("cc-ca.crt", "w") as f:
#         f.write(cockroachdb_crt)
cockroachdb_url = get_secret("cockroachdb-url")


@app.route("/")
def root():
    return f"Hello, World!\nFirst 10 chars of cert: {cockroachdb_crt[:10]}\nFirst 10 chars of url: {cockroachdb_url[:10]}"


@app.route("/location", methods=["GET"])
def getevent():
    # Get events
    # Args - longitude, latitude, (optional default 5) distance
    return "Hello, World!"


# @app.route("/addevent", methods=["POST"])
# def getevent():
#     # Add a new event
#     # Args - longitude, latitude, Animal, Photo, Username
#     return "Hello, World!"


# @app.route("/getevent", methods=["GET"])
# def getevent():
#     # Gets an event from UUID
#     # Args - Event UUID
#     return "Hello, World!"


# @app.route("/animal", methods=["POST"])
# def getevent():
#     # Search for animal and add image to DB
#     # Args - Image
#     # Returns json - animal name and url of image
#     return "Hello, World!"


@app.route("/animalsighting", methods=["POST"])
def createanimalsighting():
    location = request.json["location"]
    animals = request.json["animals"]
    poster = request.json["poster"]
    sighting = AnimalSighting(
        location=location, images=[], animals=animals, poster=poster
    )
    with Session(engine) as session:
        session.add(sighting)
        session.commit()
        r = jsonify(sighting)
        # s = json.dumps(sighting.as_dict())
    # r = Response(s, content_type="application/json")
    return r

@app.route("upload", methods=['POST'])
def upload():
    f = request.files['file']
    name = f.filename
    content = f.stream
    name = blake3(bytes(name, 'utf-8')).hexdigest()+"."+name.split('.')[-1] 

    storage_client = storage.Client()
    bucket = storage_client.bucket("decisive-router-311716.appspot.com")
    blob = bucket.blob(name)
    blob.upload_from_file(content)

    return("https://decisive-router-311716.appspot.com/"+name)


@app.route("/animalsighting/<uuid>", methods=["GET"])
def getanimalsighting(uuid):
    with Session(engine) as session:
        stmt = select(AnimalSighting).where(AnimalSighting.id == uuid)
        sighting = session.execute(stmt).first()
        r = jsonify(list(sighting._asdict().values())[0])
    return r


if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    # Flask's development server will automatically serve static files in
    # the "static" directory. See:
    # http://flask.pocoo.org/docs/1.0/quickstart/#static-files. Once deployed,
    # App Engine itself will serve those files as configured in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)
