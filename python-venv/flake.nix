{
  description = "my python project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , fenix
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ fenix.overlays.default ];
      pkgs = import nixpkgs { inherit system overlays; };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            just
            rust-components
          ];
      };
    });
}
