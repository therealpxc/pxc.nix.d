{ config, pkgs, lib, ... }:

{
  # allow us to use custom nixpkgs by cloning it into /etc/nixos
  nix.nixPath = [
    # /etc/nixos/channels/nixpkgs -> ~/Code/Personal/devnix (or wherever; it's a local checkout)
    "nixpkgs=/etc/nixos/channels/nixpkgs"

    # top-level nixos configuration file
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  # add overlays and custom packages
  nixpkgs.overlays = [
    (import ../overlays/pxc.overlay.nix)
    (import ../overlays/rust-overlay.nix)

    # add third-party packages from outside the nixpkgs tree
    (self: super: {
      home-manager = import ../pkgs/home-manager { inherit pkgs; };
      sbtix = super.callPackage ../pkgs/Sbtix/sbtix-tool.nix { };
    })
  ];

  nix.trustedUsers = [ "@wheel" ];

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

  environment.systemPackages = with pkgs;
    pxc.common.tui.pkgs ++ pxc.linux.tui.pkgs;

  # add my own user
  users.extraUsers.pxc = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "docker" "libvirtd" "vboxusers" "dialout" "cdrom" ];
  };
  users.groups = {
    wheel = { members = [ "pxc" ]; };
  };

}
