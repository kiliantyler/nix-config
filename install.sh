#!/bin/sh



sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

./bin/task nix:install
