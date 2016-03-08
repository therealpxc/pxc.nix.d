{ config, pkgs, ...}:

{

  nixpkgs.config.allowUnfree = true;
  # Select internationalisation properties.
  i18n = {
    consoleFont = "/run/current-system/sw/share/fonts/psf/ter-powerline-v20n.psf.gz";
    #consoleFont = "ter-powerline-v16n";    # TODO: fix the powerline-fonts package so that the full path is not required
#    consoleFont = "Lat2-Terminus16";       # default
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

#  nixpkgs.config.packageOverrides = { 
#  };
    
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [

    firefox-wrapper     # the wrapper means we get pluginz
    kde4.yakuake        # quake-style terminal for KDE
    lighttable          # lighttable editor
    leiningen           # Clojure project + dependency manager

    vimPlugins.vim-addon-vim2nix
    vimPlugins.vim-addon-manager
    nodePackages.bower2nix
    nodePackages.npm2nix
    pypi2nix
    python2nix
    egg2nix
    kde5.konversation
    python27Packages.docker_compose
    kde5.breeze
    #man_db
    kde5.plasma-pa
    kde5.kdeplasma-addons
    smbnetfs
    fusesmb
    cifs_utils
    kde4.cantor
    s3fs
    google-drive-ocamlfuse
    kde5.kdbusaddons
    glxinfo
    atom
    dwm
    i3
    kde5.okular
    eclipses.eclipse_sdk_451
    jdk     # openjdk 8
    jdk7    # openjdk 7
    rekonq
    x2goclient
    winswitch
    kde5.dolphin-plugins
    kde5.kio-extras
    i3status
    dmenu

    kde5.quassel
    kde4.kdesvn
    chromium
    #virtmanager
    kde5.kate
  ];

  hardware.pulseaudio.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.telepathy.enable = true;

  # this may be dangerous! this uses a kms-based console instead of getty
  # it may make my console awesome... it might fuck me
  #services.kmscon.enable = true;
  

  services.xserver.enable = true;
  #services.xserver.autorun = false; # i think we're good?
  services.xserver.layout = "us";
  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.desktopManager.kde5.phonon.gstreamer.enable = true;

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
  ];
}
