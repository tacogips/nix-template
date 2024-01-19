{
  description = "my python project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , nixpkgs-python
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      python-version = "3.9";
      pkgs = import nixpkgs {
        inherit system;
      };
      python = nixpkgs-python.packages.${system}.${python-version};
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          (python.withPackages (pypkg: with
          pypkg;[ flake8 pep8-naming black ])

          )
        ] ++ (with pkgs;
          [
            just
            nodePackages.pyright
          ]);

        shellHook = ''
          [[ -d venv ]] || python3 -m venv venv
          source venv/bin/activate

        '';
      };
    });
}
