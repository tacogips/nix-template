{
  outputs = { ... }: {
    templates = {
      rust-fenix = {
        path = ./rust-fenix;

      };

      python-venv = {
        path = ./python-venv;
      };

      python-latest = {
        path = ./python-latest;
      };

      docker = {
        path = ./docker;
      };
      zig = {
        path = ./zig;
      };
    };
  };
}
