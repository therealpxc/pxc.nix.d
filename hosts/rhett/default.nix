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

  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;

  # Use grub for EFI booting
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # boot.kernelPackages = pkgs.linuxPackages_4_14;

  # hoping this will relieve a suspend/resume issue
  boot.kernelParams = [ "intel_iommu=off" ]; # not sure that this is necessary since fbc is disabled, but I'm still having problems.

  # Network configuration
  networking.hostName = "rhett"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bt audio support

  # Handle some bluetooth hardware quirks
  hardware.enableAllFirmware = true;
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
    yubikey-personalization
    yubikey-personalization-gui
    zoom-us                                    # in case I need to join a meeting for work
    gcs                                        # for GUUUURPS
    lastpass-cli                               # for SigFig
    exfat

    androidsdk

    nextcloud-client
    calibre

    # for Emacs
    tetex
    global
    universal-ctags

    virtmanager-qt

    plasma5.user-manager

    lvm2
    f2fs-tools
    cryptsetup

    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science

  ] ++ (with pkgs.haskellPackages; [
    ghc

    # for Spacemacs' Haskell layer
    # ghc-mod # broken?
    apply-refact
    hoogle
    intero
    # hasktags
    stylish-haskell
  ]);

  services.udev.packages = with pkgs; [
    yubikey-personalization
    android-udev-rules
  ];

  hardware.u2f.enable = true;

  services.pcscd.enable = true;

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

    options i915 enable_guc_loading=1 enable_guc_submission=1 enable_fbc=0
  '';

  services.tlp.enable = true;
  # This disables setting CPU freq and running acpid
  # (Other powerManagement.* settings will still be honored!)
  # powerManagement.enable = false;
  services.tlp.extraConfig = ''
    CPU_SCALING_GOVERNOR_ON_AC=performance
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
    speed = 200;          # ranges from 0-254, kernel default 97
    sensitivity = 200;    # ranges from 0-254, kernel default 128
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    deviceSection = ''
      # Option      "AccelMethod"  "uxa"
      # Option "DRI" "2"
      Option "TearFree" "true"
    '';
    config = ''
      Section "InputClass"
        Identifier "TPPS/2 IBM TrackPoint"
        MatchProduct "TPPS/2 IBM TrackPoint"
        MatchDevicePath "/dev/input/event*"
        Option "AccelProfile" "flat"
      EndSection
    '';
    videoDrivers = [ "modesetting" ];
    exportConfiguration = true;
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

  # services.xserver.windowManager.fluxbox.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoLogin = {
    enable = true;
    user = "pxc";
  };

  services.xserver.displayManager.job.logToFile = true;

  # services.kmscon.enable = true;
  boot.earlyVconsoleSetup = true;
  i18n.consoleFont = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";

  nix.buildCores = 2;

  system.stateVersion = "18.03";
}
