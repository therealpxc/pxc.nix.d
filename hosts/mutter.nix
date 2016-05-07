# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./profiles/player.nix
    ];
  nixpkgs.config.allowUnfree = true;
  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";

  };

  networking.hostName = "mutter"; # Define your hostname.

  environment.systemPackages = with pkgs; [
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;

  services.xserver.deviceSection = ''
    #Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce GTX 750 Ti"
  '';
  
  services.xserver.defaultDepth = 24;

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
 # networking.wireless.enable = true; # does this conflict with networkmanager?
  networking.networkmanager.enable = true;

  nix.buildCores = 4;
  nix.maxJobs = 2;

}
