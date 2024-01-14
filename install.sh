#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

# This script is meant for quick & easy install via:
# curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh | sh
# if you want to target a specific directory:
# curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh | sh -s -- -d ~/nix-config

REPO_LOCATION="${HOME}/nix-config"

# check arg for custom directory
while getopts "d:" opt; do
  case $opt in
    d)
      REPO_LOCATION=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Allows us to run this as if everything were already installed
PATH="${REPO_LOCATION}/.task:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
export NIX_CONFIG="experimental-features = nix-command flakes repl-flake"

if command -v nix >/dev/null 2>&1; then
  echo "Nix already installed."
  exit 0
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not installed, please install curl and try again."
  exit 1
fi

if command -v git >/dev/null 2>&1; then
  git clone https://github.com/kiliantyler/nix-config "${REPO_LOCATION}"
# TODO: Add a curl & wget fallback using github releases
else
  echo "git not installed, please install git and try again."
  exit 1
fi

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "${REPO_LOCATION}/.task"

task -d "${REPO_LOCATION}" nix:setup-all

}
