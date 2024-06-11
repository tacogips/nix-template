{
  description = "my rust project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      rust-components = fenix.packages.${system}.fromToolchainFile
        {
          file = ./rust-toolchain.toml;
          #sha256 = nixpkgs.lib.fakeSha256;
          sha256 = "sha256-SXRtAuO4IqNOQq+nLbrsDFbVk+3aVA8NNpSZsKlVH/8=";
        };
    in

    {
      devShells.default = pkgs.mkShell
        {
          buildInputs = [ rust-components ] ++ (with pkgs;
            [
              just
            ]);
        };
    });
}
