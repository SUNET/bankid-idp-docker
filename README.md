# bankid-idp #

Build a docker for bankid-idp based on debian-bookwork-slim.

1. We first do a pre-step to add java to the resulting image.
2. In the build context we install java and maven. 
3. Build normally with maven to a local docker image.
4. We have a Dockerfile in / referencing the maven build image for jenkins to build and push to docker.sunet.se.
