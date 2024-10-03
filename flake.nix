{
  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs/23.11";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
      };
    in
    {
      packages.x86_64-linux = {
          lock = pkgs.writeShellScriptBin "lock" ''
            # Lock nixpkgs
            echo ${self.rev or self.dirtyRev or "No revision available"}
          '';
        };
    };
}
