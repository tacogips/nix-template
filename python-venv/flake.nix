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
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in

    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          (pkgs.python3.withPackages (pypkg: with
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
