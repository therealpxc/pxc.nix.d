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
#      ./profiles/hydra.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
    copyKernels = true;
    extraEntries = ''
      menuentry 'Ubuntu' {
        insmod ext2
        set root='(hd0,2)'
        chainloader +1
      }
    '';

  };

  networking.hostName = "rex"; # Define your hostname.

  environment.systemPackages = with pkgs; [
#    gazebo6
#    gazebo7
    bluez-tools

    kde5.bluez-qt
  ];

  services.redis.enable = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  services.kmscon.enable = true;

  # rex has an NVIDIA GTX 750 Ti
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  #hardware.bumblebee.enable = true;
  boot.blacklistedKernelModules = [ "i915" ];
  services.xserver.monitorSection = ''
    # HorizSync source: edid, VertRefresh source: edid
  #  Identifier     "Monitor0"
    VendorName     "Unknown"
    ModelName      "Ancor Communications Inc VS24A"
    HorizSync       30.0 - 83.0
    VertRefresh     50.0 - 61.0
    Option         "DPMS"
  '';

  services.xserver.deviceSection = ''
    #Identifier     "Device0"
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce GTX 750 Ti"
  '';
  
  services.xserver.defaultDepth = 24;
  services.xserver.screenSection = ''
    #Identifier     "Screen0"
    Device         "Device0"
    Monitor        "Monitor0"
    DefaultDepth    24
    Option         "Stereo" "0"
    Option         "nvidiaXineramaInfoOrder" "DFP-0"
    Option         "metamodes" "GPU-67c27bbf-8249-62c5-6a05-797140c598bc.DVI-I-1: nvidia-auto-select +0+0, GPU-67c27bbf-8249-62c5-6a05-797140c598bc.DP-0: nvidia-auto-select +3840+0, GPU-67c27bbf-8249-62c5-6a05-797140c598bc.HDMI-0: nvidia-auto-select +1920+0"
    Option         "MultiGPU" "Off"
    Option         "SLI" "off"
    Option         "BaseMosaic" "on"
  '';



  # rex has bluetooth + wifi
  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
 # networking.wireless.enable = true; # does this conflict with networkmanager?
  networking.networkmanager.enable = true;

  nix.buildCores = 4;
  nix.maxJobs = 2;


}
