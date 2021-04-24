from flask import Flask

# Import the Secret Manager client library.
from google.cloud import secretmanager

app = Flask(__name__)

PROJECT_ID = "decisive-router-311716"
# gets secret values
def get_secret(secret_id: str) -> str:
    """
    Access the payload for the given secret version if one exists. The version
    can be a version number as a string (e.g. "5") or an alias (e.g. "latest").
    """

    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{PROJECT_ID}/secrets/{secret_id}/versions/latest"

    # Access the secret version.
    response = client.access_secret_version(request={"name": name})

    # Print the secret payload.
    #
    # WARNING: Do not print the secret in a production environment - this
    # snippet is showing how to access the secret material.
    payload = response.payload.data.decode("UTF-8")
    return payload
    # print("Plaintext: {}".format(payload))


cockroachdb_crt = get_secret("cockroachdb-cc-ca-crt")
cockroachdb_url = get_secret("cockroachdb-url")


@app.route("/")
def root():
    return f"Hello, World!\nFirst 10 chars of cert: {cockroachdb_crt[:10]}\nFirst 10 chars of url: {cockroachdb_url[:10]}"


if __name__ == "__main__":
    # This is used when running locally only. When deploying to Google App
    # Engine, a webserver process such as Gunicorn will serve the app. This
    # can be configured by adding an `entrypoint` to app.yaml.
    # Flask's development server will automatically serve static files in
    # the "static" directory. See:
    # http://flask.pocoo.org/docs/1.0/quickstart/#static-files. Once deployed,
    # App Engine itself will serve those files as configured in app.yaml.
    app.run(host="127.0.0.1", port=8080, debug=True)
