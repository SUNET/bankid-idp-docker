#!/bin/bash
set -e
export DOCKER_REPO=docker.sunet.se
docker build -t debian:bookworm-slim-java build-pre-image

GIT_DIR="build_bankid-saml-idp"

if [ -d "${GIT_DIR}" ]; then
    pushd "${GIT_DIR}"
    git pull
else
    git clone --branch "${UPSTREAM_VERSION=main}" --depth 1 https://github.com/swedenconnect/bankid-saml-idp.git "${GIT_DIR}"
    pushd "${GIT_DIR}"
fi
mvn -version
mvn clean install

DOCKER_IMAGE="docker://debian:bookworm-slim-java" 
mvn -f bankid-idp/bankid-idp-backend jib:dockerBuild -Djib.from.image="${DOCKER_IMAGE}"
