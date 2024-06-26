# syntax=docker/dockerfile:1

FROM python:3.12-slim-bullseye
WORKDIR /app

ARG GIT_BRANCH=unknown GIT_REVISION=unknown DATE=unknown
ENV UID=1000 GID=1000 GIT_BRANCH=$GIT_BRANCH GIT_REVISION=$GIT_REVISION DATE=$DATE NB_WORKERS=5 LOG_LEVEL="info" DISABLE_REDIS='false'
VOLUME ["/app/params", "/app/data", "/app/downloads", "/app/logs"]
EXPOSE 80

# Use Python -- since it comes with the image -- to download and unpack the static ffmpeg binary
RUN pip install static-ffmpeg

COPY --chmod=755 entrypoint.sh ./
COPY *.py pip_requirements ./
COPY params/*.py params/*.ini params/userscript.js params/hooks_requirements ./setup/
COPY params/params_docker.ini ./setup/params.ini

# Just write them properly in the first place.
#RUN dos2unix * ./setup/*

RUN pip3 install -r pip_requirements

ENTRYPOINT ["/app/entrypoint.sh"]
