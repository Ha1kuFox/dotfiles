{ flake, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ] ++ builtins.attrValues flake.nixosModules;

  config.mods = {
    #cinny.enable = true;
    tailscale.enable = true;
    hardware.enable = true;
    vscode.enable = true;
    gnome.enable = true;
    language.enable = true;
    user.enable = true;
    boot = {
      enable = true;
      plymouth = true;
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
  };

  config.environment.systemPackages = with pkgs; [
    keepassxc
    ayugram-desktop
    yandex-music
    jetbrains.idea-oss
    (anytype.override {
      commandLineArgs = "--disable-gpu --enable-features=UseOzonePlatform --ozone-platform=wayland";
    })
  ];

  config.programs.nix-ld.enable = true;
  config.programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
    libGL
    glib
    libX11
    fontconfig
    freetype
  ];

  config.nixpkgs.hostPlatform = "x86_64-linux";
  config.system.stateVersion = "25.05";
}
