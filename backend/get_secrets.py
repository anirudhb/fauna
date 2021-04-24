import os
import config

# Import the Secret Manager client library.
from google.cloud import secretmanager

PROJECT_ID = "decisive-router-311716"
# gets secret values
def get_secret(secret_id: str) -> str:
    """
    Access the payload for the given secret version if one exists. The version
    can be a version number as a string (e.g. "5") or an alias (e.g. "latest").
    """
    if config.DEBUG:
        if secret_id == "cockroachdb-cc-ca-crt":
            with open("cc-ca.crt", "r") as f:
                return f.read()
        else:
            return os.environ[secret_id.upper().replace("-", "_")]

    # Create the Secret Manager client.
    client = secretmanager.SecretManagerServiceClient()

    # Build the resource name of the secret version.
    name = f"projects/{PROJECT_ID}/secrets/{secret_id}/versions/latest"

    # Access the secret version.
    response = client.access_secret_version(request={"name": name})  # type: ignore

    # Print the secret payload.
    #
    # WARNING: Do not print the secret in a production environment - this
    # snippet is showing how to access the secret material.
    payload = response.payload.data.decode("UTF-8")
    return payload
    # print("Plaintext: {}".format(payload))
