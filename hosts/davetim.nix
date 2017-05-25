# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./profiles/workstation.nix
      ./modules/xcompose
    ];
  nix.useSandbox = false;

  # Use the GRUB 2 boot loader.
  #boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda1";
  boot.loader.grub.efiSupport = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "davetim"; # Define your hostname.
  networking.networkmanager.enable = true;

  #nixup.enable = false;

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
    mesa
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  environment.shellAliases = {
    lsa = "${pkgs.coreutils}/bin/ls -lahFT0 --group-directories-first";
  };

}
