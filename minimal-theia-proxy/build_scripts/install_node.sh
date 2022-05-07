#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update \
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
        libsecret-1-dev
