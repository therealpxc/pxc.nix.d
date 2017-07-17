{ config, pkgs, lib, ... }:

{
  # import homemade packages and override pkgs
  imports = [ ./my-packages.nix ];

  # allow us to use custom nixpkgs by cloning it into /etc/nixos
  nix.nixPath = [
    # marks nixpkgs parent directory: 
    # /etc/nixos/nixpkgs -> /home/pxc/Code/Personal/devnix (local checkout)
    "nixpkgs=/etc/nixos/channels/nixpkgs"

    # top-level nixos configuration file
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nix.trustedUsers = [ "@wheel" ];

  # this is only allowable because vimmy is also installed by default, see below
  environment.extraInit = ''
    EDITOR=vim
  '';

  # Select internationalisation properties.
  i18n = {
    #consoleFont = "/run/current-system/sw/share/fonts/psf/ter-powerline-v20n.psf.gz";
    #consoleFont = "ter-powerline-v16n";    # TODO: fix the powerline-fonts package so that the full path is not required
    #consoleFont = "Lat2-Terminus16";       # default
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  services.sshd.enable = true;
  services.openssh.forwardX11 = true;
  programs.fish.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  security.sudo.enable = true;
  services.locate.enable = true;

  services.samba.enable = true;
  services.samba.nsswins = true;

  environment.systemPackages = with pkgs; [
    xpra              # in desktop.profile we also include winswitch

    lshw
    usbutils            # lsusb

    nix-repl
    nixops
    disnix
  ] ++ pxc.common.tui.pkgs
    ++ pxc.linux.tui.pkgs
  ;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.pxc = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "docker" "libvirtd" "vboxusers" "dialout" "cdrom" ];
  };
  users.groups = {
    wheel = { members = [ "pxc" ]; };
  };

}
