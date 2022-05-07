# Nipraxis Docker file for JupyterHub

## Build the image locally

```bash
# Choose your directory containing a Dockerfile
cd nipraxis-hub
../make_image.sh .
```
<<<<<<< HEAD

This will tag the resulting image with the first 7 characters of the commit from this repository.

## Push to docker hub
||||||| 8a8ab38
docker build -t matthewbrett/nipraxis:v002 .
```

## Google Container Registry

See <https://www.cloudsavvyit.com/4866/how-to-push-and-pull-docker-images-from-google-container-registry/>.

Enable GCR for project via
<https://console.cloud.google.com/apis/library/containerregistry.googleapis.com>.

Configure docker with gcloud:

```
gcloud auth configure-docker
```

Tag and push to GCR:

```
docker tag matthewbrett/nipraxis:v002 gcr.io/uob-jupyterhub/nipraxis:v002
docker push gcr.io/uob-jupyterhub/nipraxis:v002
```

## Dockerhub

This is a raw build, with a hard-coded tag:

```
docker build -t matthewbrett/nipraxis:v002 .
```

If, like me, you like to tag your images from the commit in this repository,
use this command from the relevant image directory:

```
../make_image.sh .
``

The output from `make_image.sh` above will give you the commands, but, say your
generated docker image is `matthewbrett/nipraxis-hub:123abcd`.

Either way, the image can be pushed up to Dockerhub directly.  Remember to set
the correct image name and tag:

```bash
docker login --username matthewbrett
docker push matthewbrett/nipraxis-hub:123abcd
```

If you get a "User interaction is not allowed." error at the ``login`` stage,
you may get further by running this command at the affected terminal::

```
security unlock-keychain
```

See
<https://github.com/docker/docker-credential-helpers/issues/82#issuecomment-367258282>

## Testing locally

```bash
docker run -it --rm -p 8888:8888 matthewbrett/nipraxis:001
```

then attach to <http://localhost:8888>.

This incantation allows `sudo` access and drops into a Bash shell.

```bash
docker run -it --rm -p 8888:8888 -e GRANT_SUDO=yes matthewbrett/nipraxis:001 /bin/bash
```
