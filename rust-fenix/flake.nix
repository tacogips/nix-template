{
  description = "";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fenix.url = "github:nix-community/fenix";
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
      pkgs = import nixpkgs { inherit system overlays; };
      pkgs-unstable = import nixpkgs-unstable { inherit system; };
      rust-components = fenix.packages.${system}.fromToolchainFile
        {
          file = ./rust-toolchain.toml;
          sha256 = nixpkgs.fakeSha256;
          #sha256 = "sha256-ks0nMEGGXKrHnfv4Fku+vhQ7gx76ruv6Ij4fKZR3l78=";
        };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs;
          [
            just
            rust-components
            # github action uses docker 24
            #https://github.com/actions/runner-images/blob/main/images/linux/Ubuntu2204-Readme.md#tools
            pkgs-unstable.docker_24
          ];
      };
    });
}
