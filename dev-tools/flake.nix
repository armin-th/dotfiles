{
  description = "Software development tools";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.naersk.url = "github:nix-community/naersk";
  inputs.naersk.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, naersk }:
    flake-utils.lib.eachDefaultSystem (
      system: 
        let
          pkgs = import nixpkgs { inherit system; };
          naersk-lib = naersk.lib."${system}";
        in {
          defaultPackage = import ./default.nix { inherit pkgs naersk-lib; };
          devShells.default = import ./default.nix { inherit pkgs naersk-lib; };
        }
    ); 
}
