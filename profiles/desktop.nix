{ config, pkgs, ...}:

{

  nixpkgs.config.allowUnfree = true;
  # Select internationalisation properties.
  i18n = {
#    consoleFont = "/run/current-system/sw/share/fonts/psf/ter-powerline-v20n.psf.gz";
    consoleFont = "ter-powerline-v16n";    # TODO: fix the powerline-fonts package so that the full path is not required
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
    wget
    which
    nox                 # nixos package search tool
    super-user-spark    # extremely cool dotfiles manager
    firefox-wrapper     # the wrapper means we get pluginz
    figlet              # command-line tool for rendering stylized text in ascii-art
    kde4.yakuake        # quake-style terminal for KDE
    lighttable          # lighttable editor
    leiningen           # Clojure project + dependency manager
    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub
    gitAndTools.git-annex
    gitAndTools.git-remote-hg
    silver-searcher
    byobu
    tmux
    vimPlugins.vim-addon-vim2nix
    vimPlugins.vim-addon-manager
    nodePackages.bower2nix
    nodePackages.npm2nix
    pypi2nix
    python2nix
    egg2nix
    kde5.konversation
    fzf
    fasd
    mercurialFull
    subversion
    keychain
    python27Packages.docker_compose
    kde5.breeze
    #man_db
    #pypyPackages.powerline
    python35Packages.powerline
    dvtm
    dtach
    abduco
    kde5.plasma-pa
    kde5.kdeplasma-addons
    smbnetfs
    fusesmb
    cifs_utils
    kde4.cantor
    s3fs
    sshfsFuse
    google-drive-ocamlfuse
    fuse-7z-ng
    kde5.kdbusaddons
    glxinfo
    cowsay
    atom
    dwm
    i3
    kde5.okular
    grc
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
  ];
  programs.fish.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  security.sudo.enable = true;
  services.locate.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.windowManager.i3.enable = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.lxc.enable = true;
  
    
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  
  services.samba.enable = true;
  services.samba.nsswins = true;

  services.telepathy.enable = true;

  # this may be dangerous! this uses a kms-based console instead of getty
  # it may make my console awesome... it might fuck me
  services.kmscon.enable = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.pxc = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "docker" "libvirtd" ];
  };
  users.groups = {
    wheel = { members = [ "pxc" ]; };
  };

  services.xserver.enable = true;
  #services.xserver.autorun = false; # i think we're good?
  services.xserver.layout = "us";
  services.xserver.desktopManager.kde5.enable = true;
  services.xserver.desktopManager.kde5.phonon.gstreamer.enable = true;

  # disable slim by preferring sddm; slim is apparently kinda broken
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.default = "kde5";
}
