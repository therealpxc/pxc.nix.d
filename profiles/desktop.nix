{ config, pkgs, ... }:

{
  # allow for proprietary graphics drivers ☹
  nixpkgs.config.allowUnfree = true;
  imports =
  [
    ./elements/common.nix # basic shell env
    ./elements/fonts.nix
  ];

  nixpkgs.config.firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  nixpkgs.config.chromium = {
    enablePepperFlash = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    firefox
    cutegram
    telegram-cli
    kde4.yakuake        # quake-style terminal for KDE
    kde5.ark

    vimPlugins.vim-addon-manager
    kde5.breeze
    kde5.plasma-pa
    kde5.kdeplasma-addons
    kde4.cantor
    s3fs
    google-drive-ocamlfuse
    kde5.kdbusaddons
    kde5.okular
    rekonq
    x2goclient
    winswitch
    kde5.dolphin-plugins
    kde5.kio-extras
    kde4.kdesvn
    kde5.kate
    kde5.kdesu
    kde5.kgpg
    #kde4.kmix
    kde5.spectacle
    # afaik there's no manager app for kde5-only yet
    kde4.kwalletmanager
    pavucontrol
    vlc
    pythonPackages.youtube-dl
    kde5.gwenview
    kde5.ksysguard
  ];

  hardware.pulseaudio.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.telepathy.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.windowManager = {
    #compiz.enable = true;
    dwm.enable = true;
    fluxbox.enable = true;
    icewm.enable = true;
    openbox.enable = true;
  };

  #services.xserver.desktopManager.kde5.phonon.gstreamer.enable = true;

  # disable slim by preferring sddm; slim is apparently kinda broken
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.default = "kde5";

  # printer stuff!
  services.printing.drivers = with pkgs; [
    splix
    gutenprint
    foomatic_filters
    ijs
    foo2zjs
    cups-bjnp
    cups_filters
    gutenprintBin
    samsung-unified-linux-driver
  ];
}
