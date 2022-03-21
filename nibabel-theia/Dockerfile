FROM jupyter/base-notebook:latest
# Built from... https://hub.docker.com/r/jupyter/base-notebook/
#               https://github.com/jupyter/docker-stacks/blob/HEAD/base-notebook/Dockerfile
# Built from... Ubuntu 20.04

# VULN_SCAN_TIME=2022-02-22_01:13:56

# The jupyter/docker-stacks images contains jupyterhub and jupyterlab already.

# Example install of git and nbgitpuller.
# NOTE: git is already available in the jupyter/minimal-notebook image.
USER root
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
        dnsutils \
        git \
        iputils-ping \
 && rm -rf /var/lib/apt/lists/*

COPY build_scripts/install_node_conda.sh /build_scripts/
RUN /build_scripts/install_node_conda.sh

USER $NB_USER

COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install --no-cache-dir \
    -r /tmp/requirements.txt

# Support overriding a package or two through passed docker --build-args.
# ARG PIP_OVERRIDES="jupyterhub==1.3.0"
ARG PIP_OVERRIDES=
RUN if [[ -n "$PIP_OVERRIDES" ]]; then \
        pip install --no-cache-dir $PIP_OVERRIDES; \
    fi

RUN jupyter serverextension enable --py nbgitpuller --sys-prefix
RUN jupyter serverextension enable --py jupyter_server_proxy --sys-prefix

# Uncomment the line below to make nbgitpuller default to start up in JupyterLab
#ENV NBGITPULLER_APP=lab

# Install Theia
WORKDIR /home/theia
COPY build_scripts/build_theia.sh ./build_scripts/build_theia.sh
ADD package.json ./package.json
RUN ./build_scripts/build_theia.sh
COPY theia-bin /home/theia/bin/theia
ENV PATH /home/theia/bin:$PATH

# Theia proxy
RUN git clone https://github.com/matthew-brett/jupyter-server-proxy \
  && cd jupyter-server-proxy \
  && git checkout theia-futz \
  && cd contrib/theia \
  && pip install .

# conda/pip/apt install additional packages here, if desired.

WORKDIR $HOME

ENV NIPRAXIS_STAGING_CACHE=/home/$NB_USER/shared/data

ENV THEIA_WEBVIEW_EXTERNAL_ENDPOINT={{hostname}}
