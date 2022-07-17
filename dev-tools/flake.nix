{
  description = "Software development tools";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system: 
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in {
          devShells.default = import ./default.nix { inherit pkgs; };
        }
    ); 
}
