{ flake, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    hardware.enable = true;
    vscode.enable = true;
    gnome.enable = true;
    language.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      plymouth = true;
    };
    vm = {
      enable = true;
      host = "fox";
      memory = "8192";
      cores = "4";
      autoLogin = true;
    };
    network = {
      enable = true;
      hostName = "fox";
      bypass = true;
    };
    git = {
      enable = true;
      userName = "ha1ku";
      email = "darknekodev@yandex.ru";
    };
    nix = {
      enable = true;
      helpers = {
        enable = true;
        flakePath = "/home/user/workspace/nix/dotfiles";
      };
    };
  };

  environment.systemPackages = [  ];

  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "25.05";
}
