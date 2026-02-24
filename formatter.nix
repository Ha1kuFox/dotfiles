{ pkgs, inputs, ... }:
inputs.treefmt-nix.lib.mkWrapper pkgs {
  config = {
    projectRootFile = "flake.nix";
    programs = {
      deadnix.enable = true;
      nixfmt = {
        enable = true;
        strict = true;
      };
      just.enable = true;
      prettier.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
      statix.enable = true;
    };
  };
}
