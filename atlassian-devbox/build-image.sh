#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null && pwd )"

podman build -t lscr.io/linuxserver/code-server:latest ${DIR}
