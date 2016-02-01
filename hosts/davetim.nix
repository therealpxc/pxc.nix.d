# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./data/fonts.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "davetim"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    speed = 70;
  };

  # Select internationalisation properties.
  i18n = {
#    consoleFont = "Lat2-Terminus16";
    consoleFont = "ter-powerline-v16n";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  nixpkgs.config.packageOverrides = { 
   vimmy = pkgs.vim_configurable.customize {
       name = "vim";

       vimrcConfig.customRC = ''
       " set vim shell to bash because Syntastic doesn't like fish and stuff
       set shell=/run/current-system/sw/bin/bash
       set number
       set tabstop=2
       '';
#       vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; # optional
       #vimrcConfig.vam.knownPlugins = pkgs.vimPlugins ++ mypkgs.pkgs.vimPlugins; # optional
       vimrcConfig.vam.pluginDictionaries = [
         {  names = [
              "vim2nix"
              "sensible"            # sensible defaults
              "vim-addon-nix"       # vim syntax checking for .nix files
#              "neocomplete"     # autocompletion
              "YouCompleteMe"       # better? autocompletion
              "Syntastic"           # syntax checking
              "ctrlp"               # fuzzy finder
              "Tabular"             # alignment guides
              "Supertab"            # tab completion in insert mode
              "vim-gitgutter"       # mark changed lines since last commit with a clear visual indicator in the gutter
              "fugitive"            # some kind of fancy git thing!
              "UltiSnips"           # fancy snippets
              "VimOutliner"         # vim outlining; collapse/expand trees like a cool kid
              "vim-webdevicons"     # cool unicode glyphage
#              "fireplace"       # Clojure REPL!
#              "VimClojure"          # Clojure support for vim!
#              "drgnbrg/vim-redl"    # repl debugging
              #"ag"
              #"gitv"
              "tmux-navigator"
              ]; }

       ];
    };
  };
    
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    which
    vimmy               # custom vim with plugins and stuff!
    nox                 # nixos package search tool
    super-user-spark    # extremely cool dotfiles manager
    firefox
    figlet              # command-line tool for rendering stylized text in ascii-art
    kde4.yakuake        # quake-style terminal for KDE
    lighttable          # lighttable editor
    leiningen           # Clojure project + dependency manager
    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub
    gitAndTools.git-annex
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
  ];
  programs.fish.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  security.sudo.enable = true;
  services.locate.enable = true;

  
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    config = ''
      Section "InputClass"
        Identifier "TPPS/2 IBM TrackPoint"
        MatchProduct "TPPS/2 IBM TrackPoint"
        MatchDevicePath "/dev/input/event*"
        Option "AccelProfile" "flat"
      EndSection
    '';
  };

  services.xserver.displayManager.slim.enable = true;
  services.xserver.desktopManager.kde5 =
  {
    enable = true;
    phonon.gstreamer.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.pxc = {
    isNormalUser = true;
    uid = 1000;
  };
  users.groups = {
    wheel = { members = [ "pxc" ];
    };
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
