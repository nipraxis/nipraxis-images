#!/bin/bash
pth=$1
if [ -z "$pth" ]; then
    echo Specify path to build
    exit 1
fi
if [[ -n $(git status --short) ]]; then
    git status
    echo Clean git status and commit before building image.
    exit 2
fi

name=$(basename $(realpath $pth))
tag=$(git rev-parse --short HEAD)
user=matthew-brett
img_name="${name}:${tag}"
full_name="${user}/${img_name}"

docker build -t ${full_name} ${pth}
