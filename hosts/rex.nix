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
      ./profiles/hydra-container.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "rex"; # Define your hostname.

  environment.systemPackages = with pkgs; [
#    gazebo6
#    gazebo7
    bluez-tools

    kde5.bluez-qt
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  services.kmscon.enable = true;

  # rex has an NVIDIA GTX 750 Ti
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  # rex has bluetooth + wifi
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
 # networking.wireless.enable = true; # does this conflict with networkmanager?
  networking.networkmanager.enable = true;

  nix.buildCores = 4;
  nix.maxJobs = 2;


}
