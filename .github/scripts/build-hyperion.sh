#!/bin/sh
set -e
ARCH=$1

# Log into GHCR so the builder can push via the host Docker socket.
# We don't pass --docker-user/--docker-password to the builder because
# its internal docker login defaults to Docker Hub and will fail with
# GitHub tokens.
if [ -n "${DOCKER_USER:-}" ] && [ -n "${DOCKER_PASSWORD:-}" ]; then
    echo "${DOCKER_PASSWORD}" | docker login ghcr.io -u "${DOCKER_USER}" --password-stdin
fi

docker run --rm --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock:ro \
    -v ${GITHUB_WORKSPACE:-$(PWD)}/addon-hyperion-ng:/data \
    homeassistant/amd64-builder \
    --target /data \
    --no-latest \
    --${ARCH:-all}
