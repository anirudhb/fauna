import io
import json
import time
from urllib.parse import quote, unquote, unquote_plus

from flask.wrappers import Response
import config

if __name__ == "__main__":
    config.DEBUG = True

import filetype

from dotenv import load_dotenv, find_dotenv

load_dotenv(find_dotenv())


import os

from flask.json import jsonify, JSONEncoder
from flask import Flask, request

from get_secrets import get_secret
from sql import engine, AnimalSighting
from sqlalchemy import select, func
from sqlalchemy.orm import Session
import geoalchemy2
import geomet.wkb
import binascii

from google.cloud import storage, vision
import google.auth
from google.auth.transport.requests import Request
from google.auth import compute_engine

from blake3 import blake3

import datetime
import filetype

app = Flask(__name__)

## REEEEDeploy


class CustomJSONEncoder(JSONEncoder):
    "Add support for serializing timedeltas"

    def default(self, o):
        if type(o) == datetime.timedelta:
            return str(o)
        elif type(o) == datetime.datetime:
            return o.isoformat()
        elif type(o) == geoalchemy2.WKBElement:
            return geomet.wkb.loads(binascii.a2b_hex(str(o)))["coordinates"]
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


@app.route("/user", methods=["GET"])
def user():
    user = request.args.get("user")
    with Session(engine) as session:

        query = session.query(AnimalSighting).filter(AnimalSighting.poster == user)
        res = []
        for row in query:
            res.append(row.id)
        r = jsonify(res)
    return r


@app.route("/identify", methods=["GET"])
def identify():
    try:
        uri = unquote_plus(request.args.get("url"))
    except:
        uri = "gs://fauna-images/072ac133a614a3c9373b3493ba0b48492bc69c49de8ff47b6d5b7a7f70f22731"

    client = vision.ImageAnnotatorClient()

    image = vision.Image()
    image.source.image_uri = uri

    objects = client.object_localization(image=image).localized_object_annotations

    # From https://gist.githubusercontent.com/atduskgreg/3cf8ef48cb0d29cf151bedad81553a54/raw/82f142562cf50b0f6fb8010f890b2f934093553e/animals.txt

    f = open("animals.txt", "r")
    animalslist = f.read().splitlines()
    f.close()

    for i in range(0, len(objects)):
        object_ = objects[i]
        if object_.name in animalslist:
            return object_.name

    return "Didn't find a valid animal."


@app.route("/identifyall", methods=["GET"])
def identifyall():
    try:
        uri = unquote_plus(request.args.get("url"))
    except:
        uri = "gs://fauna-images/072ac133a614a3c9373b3493ba0b48492bc69c49de8ff47b6d5b7a7f70f22731"

    client = vision.ImageAnnotatorClient()

    image = vision.Image()
    image.source.image_uri = uri

    objects = client.object_localization(image=image).localized_object_annotations

    # From https://gist.githubusercontent.com/atduskgreg/3cf8ef48cb0d29cf151bedad81553a54/raw/82f142562cf50b0f6fb8010f890b2f934093553e/animals.txt

    f = open("animals.txt", "r")
    animalslist = f.read().splitlines()
    f.close()

    s = []
    for object_ in objects:
        if object_.name in animalslist and object_.score >= 0.5:
            s.append(object_.name)

    return jsonify({"animals": s})


@app.route("/nearbyanimalsightings")
def nearbyanimalsightings():
    lat = float(request.args.get("lat"))
    lng = float(request.args.get("lng"))
    try:
        dist = float(request.args.get("dist")) * 1609.34
    except:
        dist = 8046.72
    point = f"POINT({lng} {lat})"
    with Session(engine) as session:
        # 5 miles = 8046.72 meters
        query = session.query(AnimalSighting).filter(
            AnimalSighting.coords.ST_DWithin(point, dist)
        )
        res = []
        for row in query:
            res.append(row.id)
        r = jsonify(res)
    return r


@app.route("/animalsighting", methods=["POST"])
def createanimalsighting():
    location = request.json["location"]
    coords = request.json["coordinates"]
    coords = f"POINT({coords[1]} {coords[0]})"
    animals = request.json["animals"]
    poster = request.json["poster"]
    images = request.json["images"]
    sighting = AnimalSighting(
        location=location, coords=coords, images=images, animals=animals, poster=poster
    )
    with Session(engine) as session:
        session.add(sighting)
        session.commit()
        r = jsonify(sighting)
        # s = json.dumps(sighting.as_dict())
    # r = Response(s, content_type="application/json")
    return r


def sign_url(blob: storage.Blob, *args, **kwargs):
    """cloudstorage signed url to download cloudstorage object without login
    Docs : https://cloud.google.com/storage/docs/access-control?hl=bg#Signed-URLs
    API : https://cloud.google.com/storage/docs/reference-methods?hl=bg#getobject
    """
    if config.DEBUG:
        return blob.generate_signed_url(*args, **kwargs)

    auth_request = Request()
    signing_credentials = compute_engine.IDTokenCredentials(
        auth_request,
        "",
        service_account_email="decisive-router-311716@appspot.gserviceaccount.com",
    )
    return blob.generate_signed_url(
        *args, **kwargs, credentials=signing_credentials, version="v4"
    )


@app.route("/upload", methods=["POST"])
def upload():
    content_bytes = request.stream.read()
    name = blake3(content_bytes).hexdigest()
    content_type = filetype.guess(content_bytes).mime

    storage_client = storage.Client()
    bucket = storage_client.bucket("fauna-images")
    blob = bucket.blob(name)
    blob.upload_from_file(
        io.BytesIO(content_bytes),
        content_type=content_type
        # content_type=mimetypes.guess_type(real_name)[0] or "application/octet-stream",
    )

    signed_url = sign_url(blob, expiration=datetime.timedelta(days=1))
    return jsonify(
        {
            "url": signed_url,
            "blob": name,
        }
    )


@app.route("/animalsighting/<uuid>", methods=["GET"])
def getanimalsighting(uuid):
    with Session(engine) as session:
        stmt = select(AnimalSighting).where(AnimalSighting.id == uuid)
        sighting = session.execute(stmt).first()
        r = list(sighting._asdict().values())[0]
        # sign all image urls
        storage_client = storage.Client()
        bucket = storage_client.bucket("fauna-images")
        new_images = []
        for image in r.images:
            blob = bucket.blob(image)
            new_images.append(
                sign_url(
                    blob,
                    expiration=datetime.timedelta(days=1),
                    content_type=blob.content_type,
                )
            )
        r.images = new_images
        r = jsonify(r)
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
