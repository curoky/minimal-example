#!/usr/bin/env bash
set -xeuo pipefail

docker rmi demo:link demo:nolink demo:link_chown || echo ignore

docker build . \
  --network=host \
  --file link.Dockerfile \
  --no-cache \
  --tag demo:link
docker rmi demo:link

docker build . \
  --network=host \
  --file nolink.Dockerfile \
  --no-cache \
  --tag demo:nolink
docker rmi demo:nolink

docker build . \
  --network=host \
  --file link_chown.Dockerfile \
  --no-cache \
  --tag demo:link_chown
docker rmi demo:link_chown