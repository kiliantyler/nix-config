#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

git clone https://github.com/kiliantyler/nix-config ~/.nix-config

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b ~/.nix-config/.task

~/.nix-config/.task/task -t ~/.nix-config/Taskfile.yaml nix:install

exec $SHELL

}