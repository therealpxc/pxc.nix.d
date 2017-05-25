{ config, lib, ... }:

with lib;

let 
  cfg = config.services.xserver.xcompose;
in {
    
    options.services.xserver.xcompose = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, NixOS will set appropriate environment variables for
          Compose key support in X11, and provide a rich default XCompose file.
        '';
      };

      

    };

    config = mkIf config.services.xserver.enable {
      environment = {
        etc.XCompose.source = ./pointless-extended.xcompose;
        variables.GTK_IM_MODULE = "xim";
        variables.QT4_IM_MODULE = "xim";

        # xim is an alias to compose with qt5
        variables.QT_IM_MODULE = "xim";
        variables.XCOMPOSEFILE = "/etc/XCompose";
      };

      services.xserver.xkbOptions = "compose:caps";
    };
}
