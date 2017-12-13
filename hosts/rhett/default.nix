# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../roles/workstation.nix
    ../../roles/steambox.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  nixpkgs.config.packageOverrides = superPkgs: {
    steam = superPkgs.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        # nettools       # for `hostname`, which some scripts expect
        bumblebee      # for optirun
        virtualgl      # for glxspheres
      ];
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_4_14;

  networking.hostName = "rhett"; # Define your hostname.
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  environment.systemPackages = with pkgs; [
    powertop
    redshift-plasma-applet
    redshift
  ];

  # services.redshift.enable = true;
  # services.redshift.provider = "geoclue2";

  hardware.bumblebee.enable = true;
  hardware.bumblebee.group = "video";
  hardware.bumblebee.connectDisplay = true;
  boot.extraModprobeConfig = "options bbswitch load_state=-1 unload_state=1";
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
    CPU_SCALING_GOVERNOR_ON_AC=performance
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };




  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    speed = 127;          # ranges from 0-254, kernel default 97
    sensitivity = 200;    # ranges from 0-254, kernel default 128
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

  # Enable touchpad support.
  services.xserver.libinput = {
    enable = true;
    disableWhileTyping = true;
    accelProfile = "flat";
    accelSpeed = null;
    additionalOptions = ''
      Option "ClickMethod" "clickfinger" # 2-finger right-click, 3-finger middle-click
    '';

    # This trackpad is a clickpad. Let. Let's avoid accidental clicks.
    tapping = false;
  };

  # let's get better palm rejection 😃
  services.udev.extraHwdb = ''
    libinput:name:*SynPS/2 Synaptics TouchPad:dmi:*svnLENOVO*:pvrThinkPad25*
    LIBINPUT_ATTR_PRESSURE_RANGE=15:10
    LIBINPUT_ATTR_PALM_PRESSURE_THRESHOLD=150
    ID_INPUT_WIDTH_MM=100
    ID_INPUT_HEIGHT_MM=58
    LIBINPUT_ATTR_SIZE_HINT=100x58
  '';

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "pxc";
  };
  services.xserver.desktopManager.plasma5.enable = true;

  system.stateVersion = "17.09"; # Did you read the comment?
}
