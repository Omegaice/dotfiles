#!/usr/bin/env bash
set -eou pipefail

# Build New Profile
nix build --no-link path:"$HOME/.config/nixpkgs#homeConfigurations.$USER.activationPackage"

# Delete Old Profile
nix profile remove $(nix profile list | grep home-manager-path | awk '{print $1};')

# Activate Profile
VERBOSE=1 $(nix path-info path:"$HOME/.config/nixpkgs#homeConfigurations.$USER.activationPackage")/activate