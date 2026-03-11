{ flake, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    theming.enable = true;
    tailscale.enable = true;
    hardware.enable = true;
    vscode.enable = true;
    flutter = {
      enable = true;
      user = "user";
      enableEmulator = false;
    };

    gnome.enable = true;
    hyprland.enable = true;
    # plasma.enable = true;

    language.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      silent = true;
      #plymouth = true;
    };
    firefox.enable = true;
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
    jetbrains.idea-oss
    anytype
    obsidian
    android-studio
  ];

  config.home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
  };

  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "25.05";
}
