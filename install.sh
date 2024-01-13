#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

# Allows us to run this as if everything were already installed
PATH="${HOME}/nix-config/.task:/nix/var/nix/profiles/default/bin:$PATH"

git clone https://github.com/kiliantyler/nix-config ~/nix-config

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/nix-config/.task

task -d ~/nix-config nix:setup-all

}
