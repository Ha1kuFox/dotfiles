{ flake, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    gnome.enable = true;

    language.enable = true;
    hardware.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      silent = true;
    };

    firefox.enable = true;
    tailscale.enable = true;
    network = {
      enable = true;
      hostName = "raccoon";
      bypass = true;
    };

    git = {
      enable = true;
      userName = "hasuri";
      email = "nomail@example.com";
    };

    nix = {
      enable = true;
      helpers = {
        enable = true;
        flakePath = "/home/user/dotfiles";
      };
    };

    gaming = {
      enable = true;
      steam.deckMode = true;
      minecraft = true;
    };
  };

  config.environment.systemPackages = with pkgs; [
    ayugram-desktop
  ];

  config.home-manager = {
    backupFileExtension = "backup";
    overwriteBackup = true;
  };

  config = {
    environment.variables = {
      GSK_RENDERER = "ngl";
    };
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };

  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "25.11";
}
