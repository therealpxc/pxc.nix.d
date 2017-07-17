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
    #cutegram # broken
    breeze-gtk
    breeze-icons
    breeze-qt4
    breeze-qt5

    plasma-pa
    kdeplasma-addons
    x2goclient
    winswitch
    kdesu
    kgpg
    spectacle
    # afaik there's no manager app for kde5-only yet
    kdeApplications.kwalletmanager
    pavucontrol
    pythonPackages.youtube-dl
    gwenview
    ksysguard
  ] ++ pxc.common.gui.pkgs 
    ++ pxc.linux.gui.pkgs
  ;

  hardware.pulseaudio.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.telepathy.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.xkbOptions = "terminate:ctrl_alt_bksp caps:escape";

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
