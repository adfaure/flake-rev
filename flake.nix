{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.05";
    nix2containerInput.url = "github:nlewo/nix2container";
    nix2containerInput.inputs.nixpkgs.follows = "nixpkgs";
    flakeUtils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flakeUtils, ... }:
    flakeUtils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        packages = {
          lock = pkgs.writeShellScriptBin "lock" ''
            # Lock nixpkgs
            echo tell me why ?
            echo ${self.rev or self.dirtyRev or "No revision available"}
          '';
        };
      }
    );
}
