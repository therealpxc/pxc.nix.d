# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./data/fonts.nix
      ./profiles/common.nix
      ./profiles/desktop.nix
#      ./profiles/hydra-container.nix
    ];

  nix.nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration.nix" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "davetim"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    speed = 70;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    config = ''
      Section "InputClass"
        Identifier "TPPS/2 IBM TrackPoint"
        MatchProduct "TPPS/2 IBM TrackPoint"
        MatchDevicePath "/dev/input/event*"
        Option "AccelProfile" "flat"
      EndSection
    '';
  };

  environment.systemPackages = with pkgs; [
    #emacs
    #splix
    mesa
  ];

  services.printing.drivers = with pkgs; [
    splix
    gutenprint
    foomatic_filters
    #pkgs.gutenprint 
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";
  
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

}
