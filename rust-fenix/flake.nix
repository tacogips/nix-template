{
  description = "my rust project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane"; # TODO(tacogips) use crane in CI
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows = "fenix";
    };
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , fenix
    , crane
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

      craneLib = crane.lib.${system}.overrideToolchain rust-components;
      src = craneLib.cleanCargoSource (craneLib.path ./.);
      craneBuildArgs = {
        inherit src;
        strictDeps = true;

        buildInputs = [
          # for building prost
          pkgs.protobuf
        ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          pkgs.libiconv
        ];
      };

      cargoArtifacts = craneLib.buildDepsOnly craneBuildArgs;
      cranePkg = craneLib.buildPackage
        {
          inherit cargoArtifacts src;
          cargoToml = ./Cargo.toml;
          cargoLockList = [
            ./Cargo.lock
          ];
          nativeBuildInputs = [
            # for building prost
          ];
          #buildInputs = [
          #  # Add additional build inputs here
          #] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
          #  # Additional darwin specific inputs can be set here
          #  pkgs.libiconv
          #];

        };
    in

    {
      checks =
        {
          inherit cranePkg;
        };
      devShells.default = pkgs.mkShell
        {
          buildInputs = [ rust-components ] ++ (with pkgs;
            [
              just
              nixpkgs-fmt
              taplo-cli
            ]);
        };

      formatter = {
        "*.nix" = pkgs.nixpkgs-fmt;
        "*.toml" = pkgs.taplo-cli;
      };
    });
}
