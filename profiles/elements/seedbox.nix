{ config, pkgs, ... }:

{
  services.deluge =  { enable = true; web.enable = true; };
  
  services.transmission.enable = true;
  services.transmission.settings = {
    download-dir = "/mnt/Constantine/Docks/_Lost+Found";
    incomplete-dir = "/mnt/Constantine/Docks/_Incomplete";
    incomplete-dir-enabled = true;
  };

  environment.systemPackages = with pkgs; [
    mktorrent
    python27Packages.flexget
    transmission_remote_gtk
    tribler
  ];

}
