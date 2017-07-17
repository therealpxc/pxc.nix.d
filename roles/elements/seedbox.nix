{ config, pkgs, ... }:

{
  services.deluge =  { enable = true; web.enable = true; };
  
  services.transmission.enable = true;

  environment.systemPackages = with pkgs; [
    aria
    axel
    mktorrent
    python27Packages.flexget
    transmission_remote_gtk
    tribler
  ];

  users.groups.mediakeepers.members = [ "deluge" "transmission" ];

}
