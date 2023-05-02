#!/usr/bin/dash
set -e

docker image build . -t py38_image
docker run -it --rm -v ${PWD}:/home/jovyan/ py38_image /bin/zsh
