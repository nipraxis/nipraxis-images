# Based on:
# 
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# Ubuntu 20.04 (focal)
# OS/ARCH: linux/amd64
ARG ROOT_CONTAINER=ubuntu:focal-20200925@sha256:2e70e9c81838224b5311970dbf7ed16802fbfe19e7a70b3cbfa3d7522aa285b4

ARG BASE_CONTAINER=$ROOT_CONTAINER
FROM $BASE_CONTAINER

LABEL maintainer="Nipraxis project <https://nipraxis.org>"
ARG NB_USER="jovyan"
ARG NB_UID="1000"
ARG NB_GID="100"
ARG NODE_VERSION="12.x"

# Fix DL4006
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

USER root

ENV DEBIAN_FRONTEND noninteractive

COPY build_scripts/install_node.sh /build_scripts/
RUN /build_scripts/install_node.sh $NODE_VERSION

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
    python3-dev \
    python3-pip \
    run-one \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV HOME=/home/$NB_USER

# Copy a script that we will use to correct permissions after running certain
# commands
COPY fix-permissions /usr/local/bin/fix-permissions
RUN chmod a+rx /usr/local/bin/fix-permissions

# Enable prompt color in the skeleton .bashrc before creating the default NB_USER
# hadolint ignore=SC2016
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc && \
   # Add call to conda init script see https://stackoverflow.com/a/58081608/4413446
   echo 'eval "$(command conda shell.bash hook 2> /dev/null)"' >> /etc/skel/.bashrc 

# Create NB_USER with name jovyan user with UID=1000 and in the 'users' group
# and make sure these dirs are writable by the `users` group.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

USER $NB_UID
WORKDIR $HOME

# Setup work directory for backward-compatibility
RUN mkdir /home/$NB_USER/work && \
    fix-permissions /home/$NB_USER

# Put theia binary wrapper and pip user bin on the PATH
ENV PATH $HOME/.local/bin:/home/theia/bin:$PATH

WORKDIR /tmp
COPY requirements.txt ./requirements.txt
RUN pip3 install --upgrade pip --user \
    && pip3 install --user --no-cache-dir python-language-server flake8 autopep8 pylint \
    && pip3 install --user --no-cache-dir -r requirements.txt

# Support overriding a package or two through passed docker --build-args.
# ARG PIP_OVERRIDES="jupyterhub==1.3.0"
ARG PIP_OVERRIDES=
RUN if [[ -n "$PIP_OVERRIDES" ]]; then \
        pip install --no-cache-dir $PIP_OVERRIDES; \
    fi

RUN jupyter serverextension enable --py jupyter_server_proxy

ENV THEIA_WEBVIEW_EXTERNAL_ENDPOINT={{hostname}}
WORKDIR /home/theia
COPY build_scripts/build_theia.sh ./build_scripts/build_theia.sh
ADD package.json ./package.json
RUN ./build_scripts/build_theia.sh
COPY theia-bin /home/theia/bin/theia

RUN git clone https://github.com/matthew-brett/jupyter-server-proxy \
  && cd jupyter-server-proxy \
  && git checkout theia-futz \
  && cd contrib/theia \
  && pip install .

EXPOSE 8888

# Configure container startup
ENTRYPOINT ["/tini", "-g", "--"]
CMD ["start-notebook.sh"]

# Copy local files as late as possible to avoid cache busting
COPY start.sh start-notebook.sh start-singleuser.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID

# Make python from python3
RUN ln -s $(which python3) ~/.local/bin/python

# Point Nipraxis to read-only cache
ENV NIPRAXIS_STAGING_CACHE=/home/$NB_USER/shared/data

WORKDIR $HOME
