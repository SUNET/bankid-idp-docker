#!/bin/bash
set -e
export DOCKER_REPO=docker.sunet.se
docker build -t debian:bookworm-slim-java build-pre-image

GIT_DIR="build_bankid-saml-idp"

if [ -d "${GIT_DIR}" ]; then
    rm -rf "${GIT_DIR}"
fi
echo "Using ${UPSTREAM_VERSION}."
git clone --branch "${UPSTREAM_VERSION=main}" --depth 1 https://github.com/swedenconnect/bankid-saml-idp.git "${GIT_DIR}"
pushd "${GIT_DIR}"

apt-get update
apt-get install -y openjdk-17-jdk-headless
apt-get install -y maven
mvn -version
mvn clean install

DOCKER_IMAGE="docker://debian:bookworm-slim-java" 
mvn -f bankid-idp jib:dockerBuild@local -Djib.from.image="${DOCKER_IMAGE}" -Djib.to.image="${DOCKER_REPO}/bankid-saml-idp"
