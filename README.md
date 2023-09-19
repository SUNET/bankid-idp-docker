# bankid-idp #

Build a docker for https://github.com/swedenconnect/bankid-saml-idp based on debian-bookworm-slim.
The basic workflow is:

1. We first do a pre-step to add java to the image we want to build.
2. In the build context we install java and maven. 
3. Build the upstream code with tests and use the supplied jib target to build a local docker image. 
4. We have a Dockerfile in /Dockerfile referencing the maven build image for jenkins to build and push to docker.sunet.se.
