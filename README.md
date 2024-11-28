# Home Manager dotfiles
ARCHIVED - this repo has been merged with my system-configuration, and will no
longer be updated. See [nixos-config](https://github.com/angryluck/nixos-config) instead.

## Cautions:
1. Make sure to modify the `system = "x86_64-linux";` in `flake.nix` to match the
   actual architecture
2. XMonad configuration is in this repository, but xmonad is not started nor
   installed by Home Manager - do this in `configuration.nix` instead.

## TODOS:
- [x] Merge with the system-configuration (`/etc/nixos/`)
