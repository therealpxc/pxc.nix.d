# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./profiles/player.nix
      ./profiles/elements/seedbox.nix
    ];
  
  # hardware-y stuff
  nixpkgs.config.allowUnfree = true;
  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  fileSystems = {
    "/" = { device = "/dev/sda1"; fsType = "ext4"; };
    "/mnt/Zeus" = { device = "/dev/sdb1"; fsType = "btrfs"; };
    "/mnt/Constantine" = { device = "/dev/sdc1"; fsType = "btrfs"; };
    "/home/pxc/.local/mnt/Constantine" = { device = "/dev/sdc1"; fsType = "btrfs"; };
#    "/home/pxc/.local/mnt/Constantine" = { device = "/mnt/Constantine"; fsType = "bind"; };
  };
  swapDevices = [ { device = "/dev/sda5"; } ];

  networking.hostName = "mutter"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    bluez-tools
    bluez
    bluez4
  ];

    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
      KERNEL=="uinput", MODE="0660", GROUP="users", OPTIONS+="static_node=uinput"
    '';
    boot.kernelModules = [ "uinput" ];
    boot.blacklistedKernelModules = [ "joydev" "xpad" ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

  nix.buildCores = 8;
  nix.maxJobs = 4;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  
  services.xserver.libinput.enable = true;
  services.xserver.libinput.clickMethod = "buttonareas";

  services.xserver.synaptics.enable = true;
  # for my tiny wireless keyboard, whose touchpad has no real buttons
  services.xserver.synaptics.additionalOptions = ''
    Option "LBCornerButton" "1"   # left-click
    Option "RBCornerButton" "3"   # right-click
  '';

  services.xserver.deviceSection = ''
    Driver         "nvidia"
    VendorName     "NVIDIA Corporation"
    BoardName      "GeForce GTX 750 Ti"
  '';

  # based on configuration generated by nvidia-config
  services.xserver.monitorSection = ''
    # HorizSync source: edid, VertRefresh source: edid
    VendorName     "Seiki"
    ModelName      "SEK SE42UMS"
    HorizSync       30.0 - 80.0
    VertRefresh     50.0 - 75.0
    Option         "DPMS" "False" # this TV sucks; can't do DPMS
    DisplaySize    894 563
    Option         "DPI" "208 x 210" # 2x native
  '';

  services.transmission.settings = {
    # transmission needs ownership of these directories, as in NixOS,
    # the systemd service chmods key directories.
    download-dir = "/mnt/Constantine/Docks/_Lost+Found";
    incomplete-dir = "/mnt/Constantine/Docks/_Incomplete";
    incomplete-dir-enabled = true;
  };

  hardware.bluetooth.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "pxc";
    #relogin = true;
  };

  #nixup.enable = true;
  users.users.pxc.extraGroups = [ "mediakeepers" ];
}
