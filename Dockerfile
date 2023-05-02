FROM python:3.8-slim-bullseye

LABEL maintainer "a.yoshida <a.yoshida100@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /var/local
RUN --mount=type=cache,mode=0777,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,mode=0777,target=/var/lib/apt,sharing=locked \
    sed -i 's/\/\/archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list \
&& sed -i 's/\/\/us.archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list \
&& sed -i 's/\/\/fr.archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list \
&& apt update --fix-missing \
&& apt -y install --no-install-recommends wget curl aria2 make git zsh \
    gfortran nkf ffmpeg tzdata\
    fonts-ipaexfont fonts-arphic-uming fonts-takao-gothic gnupg2 \
&& rm -rf /var/lib/apt/lists/*

ARG NB_USER="jovyan"
ARG NB_UID="1000"
RUN useradd -m -s /bin/zsh -N -u $NB_UID $NB_USER
USER $NB_USER
WORKDIR /home/$NB_USER
ENV PATH $PATH:/home/jovyan/.local/bin
COPY ./requirements.txt .
RUN --mount=type=cache,mode=0755,target=/root/.cache/pip \
    python -m pip install --upgrade pip \
&& pip install --user -r requirements.txt \
&& sed -i "s/^#font\.family.*/font.family:  IPAexGothic/g" /home/$NB_USER/.local/lib/python3.8/site-packages/matplotlib/mpl-data/matplotlibrc