{ flake, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    theming.enable = true;
    tailscale.enable = true;
    hardware.enable = true;
    vscode.enable = true;

    gnome.enable = true;
    hyprland.enable = true;

    language.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      silent = true;
    };
    firefox.enable = true;
    network = {
      enable = true;
      hostName = "deer";
      bypass = true;
    };
    git = {
      enable = true;
      userName = "setsu";
      email = "tasettsu@hotmail.com";
    };
    nix = {
      enable = true;
      helpers = {
        enable = true;
        flakePath = "/home/user/workspace/nix/dotfiles";
      };
    };
    gaming = {
      enable = true;
      steam = {
        enable = true;
        deckMode = true;
      };
      hytale = true;
      minecraft = true;
    };
  };

  config.environment.systemPackages = with pkgs; [
    keepassxc
    ayugram-desktop
    yandex-music
  ];

  config.home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
  };

  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "25.05";
}
