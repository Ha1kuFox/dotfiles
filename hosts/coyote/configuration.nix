{
  flake,
  inputs,
  pkgs,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix

      inputs.disko.nixosModules.disko
      ./disko.nix
    ]
    ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    lemurs.enable = true;
    i3.enable = true;
    language.enable = true;
    hardware.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      silent = true;
    };
    ssh.enable = true;
    network = {
      enable = true;
      hostName = "coyote";
      bypass = true;
    };
    git = {
      enable = true;
      userName = "krollehack";
      email = "krollehack@nomail.furry";
    };
    nix.enable = true;
    gaming = {
      enable = true;
      steam = {
        enable = true;
        deckMode = true;
      };
      minecraft = true;
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      alacritty
    ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    home-manager = {
      backupFileExtension = "backup";
      overwriteBackup = true;
    };

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "25.11";
  };
}
