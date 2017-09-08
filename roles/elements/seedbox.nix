{ config, pkgs, ... }:

{
  services.deluge =  { enable = true; web.enable = true; };
  
#  services.transmission.enable = true;

  environment.systemPackages = with pkgs; [
    aria
    axel
    mktorrent
    flexget
    transmission_remote_gtk
    tribler
  ];

  users.groups.mediakeepers.members = [ "deluge" "transmission" ];

}
