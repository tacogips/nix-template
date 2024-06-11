{
  description = "my python project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-23.11";
    flake-utils.url = "github:numtide/flake-utils";
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
        buildInputs =
          (with pkgs;
          [
            just
            nodePackages.pyright

            (python3.withPackages
              (pypkg:
                (import ./pydep.nix {
                  inherit pypkg;
                })
                # [ pypkg.pip pypkg.flake8 pypkg.pep8-naming pypkg.black pypkg.GitPython pypkg.pytz pypkg.beautifulsoup4 pypkg.polars ]

              ))



          ]);

        shellHook = ''
          [[ -d venv ]] || python3 -m venv venv
          source venv/bin/activate

        '';
      };
    });
}
