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
 && apt-get install -y curl \
 && curl -fsSL https://deb.nodesource.com/setup_12.x | bash - \
 && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null \
 && echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt update \
 && apt-get install -y --no-install-recommends \
        dnsutils \
        git \
        iputils-ping \
        nodejs \
        yarn \
        gcc \
        g++ \
        make \
        pkg-config \
        libsecret-1-dev \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/theia/bin
COPY package.json /opt/theia/package.json
COPY theia-bin /opt/theia/bin/theia
RUN cd /opt/theia && yarn && yarn theia build

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

RUN jupyter serverextension enable --py jupyter_server_proxy --sys-prefix

RUN cd /tmp \
  && git clone https://github.com/jupyterhub/jupyter-server-proxy \
  && cd jupyter-server-proxy \
  && cd contrib/theia \
  && pip install .

# Uncomment the line below to make nbgitpuller default to start up in JupyterLab
#ENV NBGITPULLER_APP=lab

# Put theia binary wrapper on the PATH
ENV PATH /opt/theia/bin:$PATH
