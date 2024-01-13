#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

PATH="/fakepath:$PATH"
# git clone https://github.com/kiliantyler/nix-config ~/nix-config

# sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/nix-config/.task

# ~/nix-config/.task/task -d ~/nix-config nix:setup-all

task path

}
