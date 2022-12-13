#!/usr/bin/env bash
set -eou pipefail

ROOT=$(dirname "$0")
PACKAGE=path:"$HOME/.config/nixpkgs#homeConfigurations.$USER.activationPackage"

# Build New Profile
nix build --no-link $PACKAGE

# Print Changes
UPDATE_TIME=$(date +%Y-%m-%d-%H-%M-%S)
PROFILE_NEW=$(nix path-info $PACKAGE)
PROFILE_OLD=/nix/var/nix/profiles/per-user/$USER/home-manager

mkdir -p $ROOT/changes

touch "$ROOT/changes/$UPDATE_TIME.log"
nix store diff-closures $PROFILE_OLD $PROFILE_NEW | tee "$ROOT/changes/$UPDATE_TIME.log"

ln -sf "$UPDATE_TIME.log" "$ROOT/changes/latest.log"

# Delete Old Profile
nix profile remove $(nix profile list | grep home-manager-path | awk '{print $1};')

# Activate Profile
VERBOSE=1 $PROFILE_NEW/activate