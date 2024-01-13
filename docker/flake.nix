{
  description = "docker";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    , fenix
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [ fenix.overlays.default ];
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            pkgs-unstable.docker_24
          ];

      };
    });
}
