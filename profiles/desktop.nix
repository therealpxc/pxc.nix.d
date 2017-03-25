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

  # fuck it− let's have a bootsplash!
  # just kidding − this is broken as of 2017-03-25
  # see https://github.com/NixOS/nixpkgs/issues/22292
  #boot.plymouth.enable = true;
  #boot.plymouth.themePackages = with pkgs; [ breeze-plymouth ];
  #boot.plymouth.theme = "breeze";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    firefox
    cutegram
    telegram-cli
    yakuake        # quake-style terminal for KDE
    ark

    vimPlugins.vim-addon-manager
    
    breeze-grub
    breeze-gtk
    breeze-icons
    breeze-qt4
    breeze-qt5

    plasma-pa
    kdeplasma-addons
    #cantor # no more cantor package?? 😢
    s3fs
    google-drive-ocamlfuse
    #kdeFrameworks.kdbusaddons # needed?
    okular
    #rekonq # no more rekonq
    x2goclient
    winswitch
    kdeApplications.dolphin-plugins
    kdeApplications.kio-extras
    #kdesvn # no more kdesvn
    kate
    kdesu
    kgpg
    #kmix
    spectacle
    # afaik there's no manager app for kde5-only yet
    kdeApplications.kwalletmanager
    pavucontrol
    vlc
    pythonPackages.youtube-dl
    gwenview
    ksysguard

    aspellDicts.en
    hunspellDicts.en-us
  ];

  hardware.pulseaudio.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.telepathy.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager = {
    #compiz.enable = true;
    dwm.enable = true;
    fluxbox.enable = true;
    icewm.enable = true;
    openbox.enable = true;
  };

  #services.xserver.desktopManager.phonon.gstreamer.enable = true;

  # disable slim by preferring sddm; slim is apparently kinda broken
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.default = "plasma5";

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
