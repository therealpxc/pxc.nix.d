# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstablePkgs = (import <nixos-unstable> { }).pkgs;
  stablePkgs = (import <nixos-stable> { }).pkgs;
in

{
  imports = [
    ../../roles/workstation.nix
    ../../roles/steambox.nix
    ../../roles/virtualization.nix
    ./hardware-configuration.nix # Include the results of the hardware scan.
  ];

  # Use grub for EFI booting
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_5_6;

  boot.loader.grub.enable = false;

  # hoping this will relieve a suspend/resume issue
  # temporarily allowing iommu to see if things are still bad with the 4.17 kernel
  # boot.kernelParams = [ "intel_iommu=off" ]; # not sure that this is necessary since fbc is disabled, but I'm still having problems.

  # boot.kernelParams = ["acpi_rev_override=1"];

  # I have a really small root partition. This should prevent nix-build from dying when it has to extract large files.
  boot.tmpOnTmpfs = true;

  # Network configuration
  networking.hostName = "rhett"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  # for split DNS configuration while on VPN
  # requires search domains to be set on the VPN connection in nm
  networking.networkmanager.dns = "dnsmasq";
  # networking.networkmanager.dynamicHosts = {enable = true; hostsDirs = { root = {}; }; }; # feature removed

  # hopefully sending ipv4 and ipv6 requests separately will solve my transient DNS resolution issues
  # networking.dnsSingleRequest = true;
  #networking.resolvConfOptions = [ "timeout:1" "single-request" ];

  # Enable the Linux firmware update tool
  services.fwupd.enable = true;

  # Enable some Thunderbolt 3 tools
  services.hardware.bolt.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  hardware.pulseaudio.package = pkgs.pulseaudioFull; # for bt audio support
  hardware.pulseaudio.extraConfig = ''
    # move existing streams to Bluetooth sinks when they are connected
    load-module module-switch-on-connect
  '';

  # Handle some bluetooth hardware quirks
  # hardware.enableAllFirmware = true; # disabled because FacetimeHD firmware was getting pulled in and failing: https://github.com/NixOS/nixpkgs/issues/71952
  hardware.enableRedistributableFirmware = true;
  powerManagement.resumeCommands = ''
    # After suspend, the bluetooth device (an embedded, Intel-based ‘USB’
    # adapter, apparently) in my ThinkPad 25 winds up in a strange power state.
    # It's inaccessible, and invisible to `bluetoothctl` as well as Bluez (and
    # hence likewise to the Plasma desktop). `rfkill` can see it, but reports
    # that it is blocked neither in hardware nor software. Happily, blocking it
    # and unblocking it using `rfkill` resets the power management state so as to
    # make the device usable again.

    # ${pkgs.rfkill}/bin/rfkill block bluetooth  # still needed with 4.17?
    # ${pkgs.rfkill}/bin/rfkill unblock bluetooth
  '';

  environment.shellAliases = {
    ls = null;
  };

  environment.systemPackages = with pkgs; [
    nitrokey-app
    powertop
    redshift-plasma-applet
    redshift
    yubikey-personalization
    yubikey-personalization-gui
    zoom-us                                    # in case I need to join a meeting for work
    gcs                                        # for GUUUURPS
    lastpass-cli                               # for SigFig
    exfat

    androidsdk_9_0

    nextcloud-client
    calibre

    # kdeApplications.kdepim-addons # kitinerary not building as of 2019-12-09
    kdeApplications.korganizer
    kdeApplications.kmail
    kdeApplications.kontact


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

    extra-container

  ] ++ (with pkgs.haskellPackages; [
    ghc

    # for Spacemacs' Haskell layer
    # ghc-mod # broken?
    apply-refact
    hoogle
    # intero # broken, I guess
    # hasktags
    # stylish-haskell # broken on 20.03

    # for primerun.sh
    fluxbox
  ]) ++ (with unstablePkgs; [
  ]);

  services.udev.packages = with pkgs; [
    yubikey-personalization
    android-udev-rules
  ];

  hardware.u2f.enable = true;
  hardware.nitrokey.enable = true;
  users.users.pxc.extraGroups = [ "nitrokey" ];

  services.pcscd.enable = true;

  # Since redshift is handled with the Plasma applet above, we don't need to
  # run the daemon as a system service.
  services.redshift.enable = false;

  # hardware.bumblebee.enable = true;
  # hardware.bumblebee.group = "video";
  # hardware.bumblebee.connectDisplay = true;



  # some Steam/Optimus quirks
  nixpkgs.config.packageOverrides = superPkgs: {
    steam = superPkgs.steam.override {
      withPrimus = true;
      extraPkgs = p: with p; [
        glxinfo        # for diagnostics
        nettools       # for `hostname`, which some scripts expect
        virtualgl      # for glxspheres
      ];
    };
  };

  boot.extraModprobeConfig = ''
    # Handle NVIDIA Optimus power management quirk
    # options bbswitch load_state=-1 unload_state=1

    # Handle wireless / bluetooth hardware quirks
    # options iwlwifi bt_coex_active=0 # bluetooth fails on recent kernels without this

    options i915 enable_fbc=1
  '';

  # does not seem to have helped any or changed anything really
  # boot.kernelPatches = [ {
  #    name = "thunderbolt";
  #    patch = null;
  #    extraConfig = ''
  #      THUNDERBOLT y
  #      HOTPLUG_PCI y
  #      HOTPLUG_PCI_ACPI y
  #    '';
  # } ];

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   exfat-nofuse # broken :-()
  # ];

  services.tlp.enable = true;
  # This disables setting CPU freq and running acpid
  # (Other powerManagement.* settings will still be honored!)
  # powerManagement.enable = false;
  services.tlp.extraConfig = ''
    CPU_SCALING_GOVERNOR_ON_AC=performance
    CPU_SCALING_GOVERNOR_ON_BAT=powersave
  '';

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    enableExtraSocket = true;
  };

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
      # Option "TearFree" "true"
    '';
    config = ''
      Section "InputClass"
        Identifier "TPPS/2 IBM TrackPoint"
        MatchProduct "TPPS/2 IBM TrackPoint"
        MatchDevicePath "/dev/input/event*"
        Option "AccelProfile" "flat"
      EndSection

      Section "InputClass"
        Identifier "Disable Mouse Acceleration"
        Driver "libinput"
        MatchVendor "ROCCAT"
        MatchIsPointer "on"
        Option "AccelProfile" "flat"
        Option "AccelSpeed" "0"
      EndSection
    '';
    # idr why I used to have modesetting, but I want to experiment
    # with the "intel" driver to use the firmware and get Vulkan support
    # videoDrivers = [ "modesetting" ];
    # videoDrivers = [ "intel" ];

    # jk, I'm very sick of docked video performance. Please let this help.
    # # always use the NVIDIA GPU (I'm hoping this makes using the laptop while docked better, less video dropouts)
    # hardware.nvidia = {
    #   modesetting = true;
    #   optimus_prime = {
    #     intelBusId = "00:02.0";
    #     nvidiaBusId = "02:00.0";
    #   };
    # };
    videoDrivers = [ "nvidia" ];
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

  # for flashing my Gemini
  services.udev.extraRules = ''
    ATTRS{idVendor}=="0e8d", ENV{ID_MM_DEVICE_IGNORE}="1"
    ATTRS{idVendor}=="6000", ENV{ID_MM_DEVICE_IGNORE}="1"
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
  console.earlySetup = true;
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-i16n.psf.gz";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  nix.buildCores = 2;

  system.stateVersion = "18.09";

  # just for fun
  # services.i2pd.enable = true;
  # services.i2p.enable = true;

  # for Themis testing/local dev
  networking.hosts = {
    "127.0.0.1" = [ "dev.themisbar.com" "local.themisbar.com" ];
    "178.170.84.10" =  [ "archive.is" "www.archive.is" "archive.fo" "www.archive.fo" "archive.li" "www.archive.li" ];
    # "54.87.249.43" = [ "phpup.themisbar.com" ];
    # "18.207.213.15" = [ "next.themisbar.com" ];
  };

  # Experimental Themis VPN configuration
  networking.wireguard.interfaces = {
    "wg-pxc@staging" = {
      # private key is stored via `pass`, see post-up script configuration
      privateKeyFile = "/dev/null";
      # privateKeyFile = "/etc/wireguard/keys/pxc@staging";

      ips = [ "172.20.254.1/32" ];

      peers = [
        { # staging.thbr.co
          publicKey = "0SxwJxNkbwaorNc/5XNzaZe7p0pfXmuwJce8BU+wpT0=";
          allowedIPs = [ "172.20.0.0/16" ];
          endpoint = "wg.staging.thbr.co:54977";
          presharedKeyFile = "/etc/wireguard/keys/user/pxc@staging.psk";
          persistentKeepalive = 25;
        }
      ];
    };

    "wg-pxc@prod" = {
      # private key is stored via `pass`, see post-up script configuration
      privateKeyFile = "/dev/null";
      ips = [ "172.252.254.1/32" ];

      peers = [
        { # prod.thbr.co
          publicKey = "x3+5Feq2Aqc0AukI0FTPLAsRoK4CtSdB1DfYd4+czl4=";
          allowedIPs = [ "172.252.0.0/16" ];
          endpoint = "wg.prod.thbr.co:58688";
          presharedKeyFile = "/etc/wireguard/keys/user/pxc@prod.psk";
          persistentKeepalive = 25;
        }
      ];
    };

    "wg-pxc@ops" = {
      # private key is stored via `pass`, see post-up script configuration
      privateKeyFile = "/dev/null";
      ips = [ "10.128.254.1/32" ];

      peers = [
        { # ops.thbr.co
        publicKey = "wvJMc2TZQS2E7owpa4WXzn7noIKZOiKuRj71POclOCM=";
          allowedIPs = [ "10.128.0.0/16" ];
          # endpoint = "wg.prod.thbr.co:53712";
          endpoint = " 3.221.10.224:53712";
          presharedKeyFile = "/etc/wireguard/keys/user/pxc@ops.psk";
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # ad-hoc Themis container
  # containers.themis-single = {
  #   # autoStart = true;
  #   config = { config, pkgs, ... }: {
  #     system.stateVersion = "19.09";

  #     nixpkgs.config = {
  #       php.xslSupport = true;
  #     };

  #     services.httpd = {
  #       enable = true;
  #       enablePHP = true;
  #       # enableSSL = true;
  #       adminAddr = "patrick@themisbar.com";
  #       documentRoot = "/data/themis/webapp/www";
  #     };

  #     services.rabbitmq.enable = true;
  #     services.memcached = {
  #       enable = true;
  #     };

  #     services.mysql = {
  #       enable = true;
  #       package = pkgs.mariadb; # MariaDB 10.2.17 on NixOS Unstable (to be 19.09) on 2019-03-17

  #       # TODO: fix our DB usage so we don't need this
  #       # Newer versions of SQL expect dates to be well-formed, no division by 0,
  #       # proper GROUP BY and ORDER BY statements, and more. Much of our application
  #       # was written prior to the standardization of these expectations, and in
  #       # violation of them. This tells our SQL server to chill out about it.
  #       # initialScript = "set GLOBAL sql_mode = '';";
  #       rootPassword = "themis rules!";

  #     };

  #     networking.firewall.allowedTCPPorts = [ 80 ];
  #   };

  #   bindMounts = {
  #     "/data/themis/webapp" = {
  #       hostPath = "/home/pxc/Code/Themis/admin";
  #       isReadOnly = false;
  #     };
  #   };
  # };

  zramSwap.enable = true;
}
