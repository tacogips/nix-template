{
  outputs = { ... }: {
    templates = {
      rust-fenix = {
        path = ./rust-fenix;

      };

      python-venv = {
        path = ./python-venv;
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
