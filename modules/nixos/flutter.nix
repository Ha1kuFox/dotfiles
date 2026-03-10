{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.mods.flutter;

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";
    platformVersions = [
      "36"
      "35"
      "34"
    ];
    buildToolsVersions = [
      "35.0.0"
      "34.0.0"
    ];
    includeEmulator = cfg.enableEmulator;
    includeSystemImages = cfg.enableEmulator;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [
      "x86_64"
      "arm64-v8a"
    ];
    extraLicenses = [
      "android-googletv-license"
      "android-sdk-arm-dbt-license"
      "android-sdk-license"
      "android-sdk-preview-license"
      "google-gdk-license"
      "intel-android-extra-license"
      "intel-android-sysimage-license"
      "mips-android-sysimage-license"
    ];
  };

  androidSdk = androidComposition.androidsdk;

  # Все подряд ибо нефиг как говориться
  desktopLibs = with pkgs; [
    at-spi2-atk
    atk
    cairo
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libdatrie
    libepoxy
    libselinux
    libsepol
    libthai
    libX11
    libXcursor
    libXext
    libXinerama
    libXi
    libXrandr
    libXrender
    pango
    pcre2
    util-linux
    zlib
    libGL
    libGLU
    mesa
    libpulseaudio
    alsa-lib
  ];
in
flake.lib.mkMod {
  inherit lib config;
  name = "flutter";

  options = {
    addToKvmGroup = flake.lib.mkBool lib true "Добавить в группу kvm (аппаратное ускорение эмулятора)";
    enableAdb = flake.lib.mkBool lib true "Включить ADB и добавить пользователя в группу adbusers";
    user = flake.lib.mkStr lib "" "Имя пользователя, для которого настраивается Flutter";
    enableEmulator = flake.lib.mkBool lib true "Включить Android эмулятор и system images";
  };

  configs = lib.mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };

    environment.systemPackages =
      with pkgs;
      [
        flutter
        androidSdk
        android-tools
        jdk17
        cmake
        ninja
        pkg-config
        # firebase-tools # https://github.com/firebase/firebase-tools/issues/9781
      ]
      ++ desktopLibs;

    environment.variables = {
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
      ANDROID_HOME = "${androidSdk}/libexec/android-sdk";
      JAVA_HOME = pkgs.jdk17.home;
      GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${androidSdk}/libexec/android-sdk/build-tools/35.0.0/aapt2";
    };
    environment.sessionVariables.LD_LIBRARY_PATH = lib.mkMerge [
      (lib.splitString ":" (lib.makeLibraryPath desktopLibs))
    ];
    environment.shellInit = ''
      export PATH=$PATH:${androidSdk}/libexec/android-sdk/platform-tools
      export PATH=$PATH:${androidSdk}/libexec/android-sdk/cmdline-tools/latest/bin
      export PATH="$PATH":"$HOME/.pub-cache/bin"
    ''
    + lib.optionalString cfg.enableEmulator ''
      export PATH=$PATH:${androidSdk}/libexec/android-sdk/emulator
    '';

    users.users = lib.mkIf (cfg.user != "") {
      ${cfg.user}.extraGroups =
        (lib.optional cfg.addToKvmGroup "kvm") ++ (lib.optional cfg.enableAdb "adbusers");
    };
  };
}
