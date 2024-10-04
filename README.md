# flake-rev: Documenting `override-input` Side Effect

This repository contains a simple flake that documents a behavior where using `override-input` results in losing the revision information in the flake's `self` variable.

## Behavior

The script in the flake simply echoes the current revision using:

```nix
lock = pkgs.writeShellScriptBin "lock" ''
  # Lock nixpkgs
  echo ${self.rev or self.dirtyRev or "No revision available"}
'';
```

When overriding an input with `--override-input`, the `self` variable in the flake no longer contains any information about the flake revision (not even `self.dirtyRev`). This behavior can be observed when running commands that utilize the above script in a `flake.nix`.

Example of the behavior:

```bash
❯ nix run github:adfaure/flake-rev/main#packages.x86_64-linux.lock --refresh
warning: input 'flakeUtils' has an override for a non-existent input 'nixpkgs'
cfcec008ec5dd8729aa48bef3145828c2d7a1b5e

❯ nix run --override-input nixpkgs github:NixOS/nixpkgs/23.11 github:adfaure/flake-rev/main#packages.x86_64-linux.lock
warning: input 'flakeUtils' has an override for a non-existent input 'nixpkgs'
warning: not writing modified lock file of flake 'github:adfaure/flake-rev/main':
• Updated input 'nixpkgs':
    'github:NixOS/nixpkgs/63dacb46bf939521bdc93981b4cbb7ecb58427a0' (2024-05-31)
  → 'github:NixOS/nixpkgs/057f9aecfb71c4437d2b27d3323df7f93c010b7e' (2023-11-29)
No revision available
```
