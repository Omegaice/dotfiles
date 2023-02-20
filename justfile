home := env_var('HOME')
current_user := env_var('USER')
package := "path:"+home+"/.config/nixpkgs#homeConfigurations."+current_user+".activationPackage"
current_profile := "/nix/var/nix/profiles/per-user/"+current_user+"/home-manager"
build_command := if `type nom || true` =~ ".*not found" { 'nix' } else { 'nom' }
compare_command := if `type nvd || true` =~ ".*not found" { 'nix store diff-closures' } else { 'nvd diff' }

default:
    @just --list

# Update flake dependencies
update:
    nix flake update

# Run checks against flake
check:
    nix flake check

# Build home-manager activation package
build:
    nix build --no-link {{ package }}    

# Compare latest values to current system
compare: build
    {{ compare_command }} /nix/var/nix/profiles/per-user/{{ current_user }}/home-manager `nix path-info {{ package }}`

# Remove old activation package
cleanup: build
    nix profile remove $(nix profile list | grep home-manager-path | awk '{print $1};')

# Activate latest home-manager package
upgrade $VERBOSE="1": cleanup
    `nix path-info {{ package }}`/activate