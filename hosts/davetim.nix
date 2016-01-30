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

  networking.hostName = "davetim"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  nixpkgs.config.packageOverrides = { 
   vimmy = pkgs.vim_configurable.customize {
       name = "vim";
       vimrcConfig.customRC = ''
       # set vim shell to bash because Syntastic doesn't like fish and stuff
       set shell=/run/current-system/sw/bin/bash
       '';
       vimrcConfig.vam.pluginDictionaries = [
         {  names = [ 
              "sensible"     # sensible defaults
#              "vim-addon-nix"
              "neocomplete"  # autocompletion
              "Syntastic"    # syntax checking
              "ctrlp"        # fuzzy finder
              "Tabular"      # alignment guides
              "Supertab"     # tab completion in insert mode
              ]; }

       ];
    };
  };
    
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget vimmy nox
  ];
  programs.fish.enable = true;
  security.sudo.enable = true;
  
  services.avahi.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

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
  users.defaultUserShell = "/run/current-system/sw/bin/fish";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
