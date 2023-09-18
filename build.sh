#!/bin/bash
set -e
export DOCKER_REPO=local
docker build -t debian:bookworm-slim-java .

GIT_DIR="build_bankid-saml-idp"

if [ -d "${GIT_DIR}" ]; then
    pushd "${GIT_DIR}"
    git pull
else
    git clone --branch "${UPSTREAM_VERSION=main}" --depth 1 https://github.com/swedenconnect/bankid-saml-idp.git "${GIT_DIR}"
    pushd "${GIT_DIR}"
fi
apt install -y openjdk-17-jdk-headless
apt install -y maven
mvn -version
mvn clean install

DOCKER_IMAGE="docker://debian:bookworm-slim-java" 
mvn -f bankid-idp/bankid-idp-backend jib:dockerBuild  -Djib.from.image="${DOCKER_IMAGE}"
