{ config, pkgs, ... }:

{
  imports =
  [
    ./nixos.nix # basic shell env
  ];

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

  # enable sound
  hardware.pulseaudio.enable = true;

  # enable mDNS
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

  # enable lots of fonts for desktop use
  fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      # microsoft & microsoft-compatibility
      vistafonts
      liberation_ttf
      comic-neue
      carlito
      corefonts
      dosemu_fonts

      # general-purpose
      ttf_bitstream_vera
      dejavu_fonts
      ubuntu_font_family

      # my favorite fonts
      libertine

      # extended unicode & special
      symbola
      clearlyU
      unifont
      freefont_ttf
      cm_unicode
      ucsFonts
      junicode


      # terminal & coding, monospace
      inconsolata
      dosemu_fonts
      anonymousPro
      source-code-pro # used by XEmacs

      # tex & typesetting
      (pkgs.ghostscript + "/share/ghostscript/fonts/")
      stix-otf
      xorg.fontadobe100dpi
      xorg.fontadobe75dpi
      xorg.fontadobeutopia100dpi
      xorg.fontadobeutopia75dpi
      xorg.fontadobeutopiatype1
      lmmath
      lmodern

      hasklig
      powerline-fonts
      nerdfonts
    ];
  };

}
