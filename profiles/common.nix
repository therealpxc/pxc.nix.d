{ config, pkgs, ...}:

{
  # import homemade packages and override pkgs
  imports = [ ../pkgs/my-packages.nix ];

  # allow us to use custom nixpkgs by cloning it into /etc/nixos
  nix.nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration.nix" ];

  # this is only allowable because vimmy is also installed by default, see below
  environment.extraInit = ''
    EDITOR=vim
  '';

  services.nfs.server.enable = true;
  services.sshd.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = "/run/current-system/sw/bin/fish";
  security.sudo.enable = true;
  services.locate.enable = true;
  
  services.samba.enable = true;
  services.samba.nsswins = true;
  
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.lxc.enable = true;
  
  environment.systemPackages = with pkgs; [
    vimmy
    xpra              # in desktop.profile we also include winswitch
    p7zip
    cowsay
    fuse-7z-ng
    sshfsFuse
    nfs-utils
    vagrant
    linuxPackages.virtualbox
    
    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub
    gitAndTools.git-annex
    gitAndTools.git-remote-hg
    super-user-spark    # extremely cool dotfiles manager

    wget
    which
    nox                 # nixos package search tool
    dvtm
    dtach
    abduco
    figlet              # command-line tool for rendering stylized text in ascii-art

    # used by my fancy fish config
    grc
    utillinuxCurses   # used by oh-my-fish
    silver-searcher
    byobu
    tmux
    python35Packages.powerline
    fzf
    fasd
    mercurialFull
    subversion
    keychain
  ];
  
    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.pxc = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "users" "docker" "libvirtd" ];
  };
  users.groups = {
    wheel = { members = [ "pxc" ]; };
  };

}
