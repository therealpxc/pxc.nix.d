{ config, pkgs, ... }:
{
    users.users = {
      pxc = {
        isNormalUser = true;
        createHome = true;
        group = "users";
        extraGroups = [ "wheel" "nixconf" ];
	uid = 1001;
      };
  };
}
