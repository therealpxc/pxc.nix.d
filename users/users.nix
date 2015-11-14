{ config, pkgs, ... }:

{
  imports = 
    [
      ./pxc.nix
    ];
  users = {
    groups = { nixconf = {}; users = {}; };
    users = {
      guest = {
        isNormalUser = true;
        createHome = true;
        initialPassword = "guest";
	uid = 999;
      };
    };
  };
}
