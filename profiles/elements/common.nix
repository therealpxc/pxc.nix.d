{ config, pkgs, ... }:

{
  # import homemade packages and override pkgs
  imports = [ ./my-packages.nix ];

  # allow us to use custom nixpkgs by cloning it into /etc/nixos
  nix.nixPath = [
    # marks nixpkgs parent directory: 
    # /etc/nixos/nixpkgs -> /home/pxc/Code/Personal/devnix (local checkout)
    "/etc/nixos"

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
    consoleFont = "/run/current-system/sw/share/fonts/psf/ter-powerline-v20n.psf.gz";
    #consoleFont = "ter-powerline-v16n";    # TODO: fix the powerline-fonts package so that the full path is not required
    #consoleFont = "Lat2-Terminus16";       # default
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  services.sshd.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  security.sudo.enable = true;
  services.locate.enable = true;

  services.samba.enable = true;
  services.samba.nsswins = true;

  environment.systemPackages = with pkgs; [
    vimmy
    xpra              # in desktop.profile we also include winswitch
    p7zip
    cowsay
    fuse-7z-ng
    sshfsFuse
    nfs-utils
    smbnetfs
    fusesmb
    cifs_utils
    jre

    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub
    gitAndTools.git-annex
    gitAndTools.git-remote-hg
    super-user-spark    # extremely cool dotfiles manager

    wget
    which
    lshw
    nox                 # nixos package search tool
    dvtm
    dtach
    abduco
    figlet              # command-line tool for rendering stylized text in ascii-art

    htop
    nix-repl
    p7zip
    nixops
    disnix

    gollum              # for editing GitLab
    weechat             # IRC for cool kidz

    # used by my fancy fish config
    grc
    #utillinuxCurses    # used by oh-my-fish
    silver-searcher
    byobu
    tmux
    python35Packages.powerline
    fzf
    fasd
    mercurialFull
    subversion
    keychain
    mawk              # used by fasd
    xsel              # used by pbcopy
    python27Full
  ];

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
