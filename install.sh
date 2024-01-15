#!/bin/sh
{ # Prevents execution if this script was only partially downloaded

# This script is meant for quick & easy install via:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh)"
# Default is to run this in interactive mode, if you want to run this in non-interactive mode:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/kiliantyler/nix-config/master/install.sh)" -- -n -d <folder> -r <repo> -b <branch>
# Arguments:
# -d <folder>: Directory to install nix-config to
# -r <repo>: Git repo to install from
# -b <branch>: Branch to install from
# -n: Non-interactive mode

# run sudo so that it doesn't ask for a password later on
echo "Asking for sudo permissions so it doesn't ask for a password later on..."
sudo echo "Starting nix-config install..."

GIT_REPO="https://github.com/kiliantyler/nix-config"
CONFIG_DIR="${HOME}/nix-config"
BRANCH="master"
NON_INTERACTIVE=false

# check for arguments
while getopts ":d:b:nr:" opt; do
  case $opt in
    d)
      CONFIG_DIR=$OPTARG
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
      exit 1
      ;;
  esac
done

if [ "${NON_INTERACTIVE}" = false ]; then
  echo "Enter the directory to install nix-config to (default: ${CONFIG_DIR}):"
  read -r config_dir
  if [ -n "$config_dir" ]; then
    CONFIG_DIR=$config_dir
  fi
  echo "Enter the git repo to install from (default: ${GIT_REPO}):"
  read -r git_repo
  if [ -n "$git_repo" ]; then
    GIT_REPO=$git_repo
  fi
  echo "Enter the branch to install from (default: ${BRANCH}):"
  read -r branch
  if [ -n "$branch" ]; then
    BRANCH=$branch
  fi
  echo "This script will install nix-config (${BRANCH}) to ${CONFIG_DIR}."
  echo "Continue? (y/N)"
  read -r response
  if ! echo "$response" | grep -E '^[yY][eE]?[sS]?$' >/dev/null 2>&1; then
    echo "Aborting."
    exit 1
  fi

fi

if [ -d "${CONFIG_DIR}" ]; then
  echo "Directory ${CONFIG_DIR} already exists, please remove it and try again."
  exit 1
fi

# Allows us to run this as if everything were already installed
PATH="${CONFIG_DIR}/.task:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"

# Check if nix is already installed
# This has to be done after the PATH is set
if command -v nix >/dev/null 2>&1; then
  echo "Nix already installed."
  exit 0
fi

# Required for flakes to work in nix-command without having to set it in ~/.config/nix/nix.conf
export NIX_CONFIG="experimental-features = nix-command flakes repl-flake"
# Required for task to use the correct config directory
export CONFIG_DIR="${CONFIG_DIR}"

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not installed, please install curl and try again."
  exit 1
fi

if command -v git >/dev/null 2>&1; then
  git clone -b "${BRANCH}" "${GIT_REPO}" "${CONFIG_DIR}"
# TODO: Add a curl & wget fallback using github releases
else
  echo "git not installed, please install git and try again."
  exit 1
fi

sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b "${CONFIG_DIR}/.task"

task -d "${CONFIG_DIR}" nix:setup-all

}
