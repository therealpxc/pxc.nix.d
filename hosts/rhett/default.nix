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



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_4_14;

  # Network configuration
  networking.hostName = "rhett"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bt audio support

  # Handle some bluetooth hardware quirks
  hardware.enableRedistributableFirmware = true;
  powerManagement.resumeCommands = ''
    # After suspend, the bluetooth device (an embedded, Intel-based ‘USB’
    # adapter, apparently) in my ThinkPad 25 winds up in a strange power state.
    # It's inaccessible, and invisible to `bluetoothctl` as well as Bluez (and
    # hence likewise to the Plasma desktop). `rfkill` can see it, but reports
    # that it is blocked neither in hardware nor software. Happily, blocking it
    # and unblocking it using `rfkill` resets the power management state so as to
    # make the device usable again.

    ${pkgs.rfkill}/bin/rfkill block bluetooth
    ${pkgs.rfkill}/bin/rfkill unblock bluetooth
  '';

  environment.systemPackages = with pkgs; [
    powertop
    redshift-plasma-applet
    redshift
  ];

  # Since redshift is handled with the Plasma applet above, we don't need to
  # run the daemon as a system service.
  services.redshift.enable = false;

  hardware.bumblebee.enable = true;
  hardware.bumblebee.group = "video";
  hardware.bumblebee.connectDisplay = true;
  # some Steam/Optimus quirks
  nixpkgs.config.packageOverrides = superPkgs: {
    steam = superPkgs.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        nettools       # for `hostname`, which some scripts expect
        bumblebee      # for optirun
        virtualgl      # for glxspheres
      ];
    };
  };

  boot.extraModprobeConfig = ''
    # Handle NVIDIA Optimus power management quirk
    options bbswitch load_state=-1 unload_state=1

    # Handle wireless / bluetooth hardware quirks
    options iwlwifi bt_coex_active=0 # bluetooth fails on recent kernels without this
  '';

  services.tlp.enable = true;
  # This disables setting CPU freq and running acpid
  # (Other powerManagement.* settings will still be honored!)
  powerManagement.enable = false;
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
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "pxc";
  };

  system.stateVersion = "17.09"; # Did you read the comment?
}
