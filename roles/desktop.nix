{ config, pkgs, ... }:

{
  imports =
  [
    ./nixos.nix # basic shell env
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
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
    kdeApplications.kwalletmanager
    pavucontrol
    pythonPackages.youtube-dl
    gwenview
    ksysguard
    touchegg
  ] ++ pxc.common.gui.pkgs
    ++ pxc.linux.gui.pkgs
  ;

  boot.plymouth.enable = true;

  # Samba slows down boot significantly, so on desktops we'll prefer
  # to load it after the GUI.
  # systemd.targets.samba.wantedBy = [ "graphical.target" ];
  # systemd.targets.samba.after = [ "samba-setup.service" "network.target" "display-manager.service" ];

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
    fontconfig = {
      enable = true;
      ultimate.enable = true;
    };

    enableFontDir = true;
    enableCoreFonts = true;
    enableDefaultFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      # actual proprietary OS-vendor fonts
      vistafonts

      # metric-compatible OS-vendor fonts
      liberation_ttf
      comic-neue
      carlito
      caladea
      kochi-substitute
      comic-relief
      liberationsansnarrow
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
      source-code-pro     # for Spacemacs

      # tex & typesetting
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
