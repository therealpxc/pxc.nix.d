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
  
  environment.systemPackages = with pkgs; [
    vimmy
    xpra              # in desktop.profile we also include winswitch
    p7zip
    utillinuxCurses   # used by oh-my-fish
  ];
}
