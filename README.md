# Nipraxis Docker file for JupyterHub

## Build the image locally

```bash
# Choose your directory containing a Dockerfile
cd nipraxis-hub
../make_image.sh .
```

This will tag the resulting image with the first 7 characters of the commit from this repository.

## Push to docker hub

The output from `make_image.sh` above will give you the commands, but, say your generated docker image is `matthewbrett/nipraxis-hub:123abcd`.  Then:

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
