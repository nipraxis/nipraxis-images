FROM jupyter/base-notebook:latest
# Built from... https://hub.docker.com/r/jupyter/base-notebook/
#               https://github.com/jupyter/docker-stacks/blob/HEAD/base-notebook/Dockerfile
# Built from... Ubuntu 20.04

# VULN_SCAN_TIME=2022-02-22_01:13:56

# The jupyter/docker-stacks images contains jupyterhub and jupyterlab already.

# Example install of git and nbgitpuller.
# NOTE: git is already available in the jupyter/minimal-notebook image.
USER root

RUN conda uninstall -y nodejs

COPY build_scripts/install_node.sh build_scripts/build_theia.sh /build_scripts/
RUN /build_scripts/install_node.sh

WORKDIR /home/theia
COPY package.json ./package.json
COPY theia-bin ./bin/theia
RUN /build_scripts/build_theia.sh

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
ENV PATH /home/theia/bin:$PATH
