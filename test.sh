#!/bin/bash
#
# ./test.sh <DOCKER_IMAGE>
#
DOCKER_IMAGE=$1

# Set working directory to that of this script for running anywhere.
cd "$(dirname $0)"

#
# Fail if anything goes wrong.
#
# -e if a single line fails, the script fails.
# -o when using pipes, detect failures within the stream(s).
set -eo pipefail

# Enable debug mode
#
# This can be passed as an environment variable directly.
# DEBUG=true ./tests.sh
#
[ "$DEBUG" ] && set -x

# Test if the docker image exists locally.
#
if ! docker inspect "$DOCKER_IMAGE" &> /dev/null; then

    echo The docker image \"$DOCKER_IMAGE\" does not exists locally.
    false

fi