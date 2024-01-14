#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

# This script is meant for quick & easy install via:
# curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh | sh
# Default is to run this in interactive mode, if you want to run this in non-interactive mode:
# curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh | sh -s -- -d ~/nix-config -b testingbranch -n
# Arguments:
# -d <folder>: Directory to install nix-config to
# -r <repo>: Git repo to install from
# -b <branch>: Branch to install from
# -n: Non-interactive mode

if command -v nix >/dev/null 2>&1; then
  echo "Nix already installed."
  exit 0
fi

GIT_REPO="https://github.com/kiliantyler/nix-config"
REPO_LOCATION="${HOME}/nix-config"
BRANCH="master"
NON_INTERACTIVE=false

while getopts "d:b:n:r:" opt; do
  case $opt in
    d)
      REPO_LOCATION=$OPTARG
      ;;
    b)
      BRANCH=$OPTARG
      ;;
    r)
      GIT_REPO=$OPTARG
      ;;
    n)
      NON_INTERACTIVE=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ "${NON_INTERACTIVE}" = false ]; then
  echo "Enter the directory to install nix-config to (default: ${REPO_LOCATION}):"
  read -r response
  if [ -n "$response" ]; then
    REPO_LOCATION=$response
  fi
  echo "Enter the git repo to install from (default: ${GIT_REPO}):"
  read -r response
  if [ -n "$response" ]; then
    GIT_REPO=$response
  fi
  echo "Enter the branch to install from (default: ${BRANCH}):"
  read -r response
  if [ -n "$response" ]; then
    BRANCH=$response
  fi
  echo "This script will install nix-config (${BRANCH}) to ${REPO_LOCATION}."
  echo "Continue? (y/n)"
  read -r response
  if [ "$response" != "y" ]; then
    echo "Aborting."
    exit 1
  fi
fi

if [ -d "${REPO_LOCATION}" ]; then
  echo "Directory ${REPO_LOCATION} already exists, please remove it and try again."
  exit 1
fi

# Allows us to run this as if everything were already installed
PATH="${REPO_LOCATION}/.task:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"

# Required for flakes to work in nix-command without having to set it in ~/.config/nix/nix.conf
export NIX_CONFIG="experimental-features = nix-command flakes repl-flake"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not installed, please install curl and try again."
  exit 1
fi

if command -v git >/dev/null 2>&1; then
  git clone -b "${BRANCH}" "${GIT_REPO}" "${REPO_LOCATION}"
# TODO: Add a curl & wget fallback using github releases
else
  echo "git not installed, please install git and try again."
  exit 1
fi

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "${REPO_LOCATION}/.task"

task -d "${REPO_LOCATION}" nix:setup-all

}
