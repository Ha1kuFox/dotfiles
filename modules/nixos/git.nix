{
  flake,
  lib,
  config,
  ...
}:
let
  cfg = config.mods.git;
in
flake.lib.mkMod {
  inherit lib config;
  name = "git";

  options = {
    userName = flake.lib.mkStr lib "User" "Git user name";
    email = flake.lib.mkStr lib "user@example.com" "Git user email";
  };

  configs = {
    programs.git = {
      enable = true;
      config = {
        user = {
          name = cfg.userName;
          inherit (cfg) email;
        };
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        pull.rebase = true;
        alias = {
          st = "status";
          co = "checkout";
          br = "branch";
          cm = "commit";
          ps = "push";
          pl = "pull";
        };
      };
    };
  };
}
