{ config, pkgs, ... }:

{
  imports =
    [
    ./nixos.nix # basic shell env
  ];

  environment.systemPackages = with pkgs; [
    breeze-gtk
    breeze-icons
    #    breeze-qt4 # disabled for nixos-18.03
    breeze-qt5

    plasma-pa
    kdeplasma-addons
    x2goclient
    # winswitch # broken?
    kdesu
    kgpg
    spectacle
    kdeApplications.kwalletmanager
    pavucontrol
    pythonPackages.youtube-dl
    gwenview
    ksysguard
    # touchegg
    libsForQt5.phonon-backend-vlc
    phonon-backend-vlc
  ] ++ pxc.common.gui.pkgs
    ++ pxc.linux.gui.pkgs
  ;

  # let's have a bootsplash!
  boot.plymouth = {
    enable = true;

    # # this is done by default in NixOS 18.03, but not yet
    # themePackages = with pkgs; [
    #   plymouth (breeze-plymouth.override {
    #     nixosBranding = true;
    #     # nixosVersion = config.system.nixosRelease;
    #   })
    # ];
    # theme = "breeze";
  };

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
  services.xserver.desktopManager.plasma5.enableQt4Support = true;

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
    hplip
  ];

  # enable lots of fonts for desktop use
  fonts = {
    fontconfig = {
      penultimate.enable = false; # true by default
      ultimate.enable = true;
      useEmbeddedBitmaps = true;
      cache32Bit = true;
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
      nerdfonts           # including Sauce Code Pro for Spacemacs
    ];
  };

}
