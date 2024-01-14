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
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      pkgs = import nixpkgs { inherit system; };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs-unstable.docker_24
        ];

      };
    });
}
