#!/bin/bash
set -e
export DOCKER_REPO=docker.sunet.se
docker build -t debian:bookworm-slim-java build-pre-image

for version in ${UPSTREAM_VERSIONS}; do
    GIT_DIR="build_bankid-saml-idp"

    if [ -d "${GIT_DIR}" ]; then
        rm -rf "${GIT_DIR}"
    fi
    echo "Using ${version}."
    git clone --branch "${version=main}" --depth 1 https://github.com/swedenconnect/bankid-saml-idp.git "${GIT_DIR}"
    pushd "${GIT_DIR}"

    apt-get update
    apt-get install -y openjdk-17-jdk-headless
    apt-get install -y maven
    mvn -version
    mvn --batch-mode --no-transfer-progress clean install

    DOCKER_IMAGE="docker://debian:bookworm-slim-java" 

    #patch to use new test cert
    cp ../FPTestcert5_20240610.pem bankid-api/src/main/resources/trust/bankid-trust-test.crt
    mvn --batch-mode --no-transfer-progress -f bankid-idp jib:dockerBuild@local -Djib.from.image="${DOCKER_IMAGE}" -Djib.to.image="${DOCKER_REPO}/bankid-idp:${version}"
    docker push "${DOCKER_REPO}/bankid-idp:${version}"
    popd
done
