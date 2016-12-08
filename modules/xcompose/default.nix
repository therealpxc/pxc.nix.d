{ config, lib, ... }: with lib;
{
  config = mkIf config.services.xserver.enable {
    environment = {
      etc.XCompose.source = ./pointless-extended.xcompose;
      variables.GTK_IM_MODULE = "xim";
      variables.QT4_IM_MODULE = "xim";

      # xim is an alias to compose with qt5
      variables.QT_IM_MODULE = "compose";
      variables.XCOMPOSEFILE = "/etc/XCompose";
    };

    services.xserver.xkbOptions = "compose:caps";
  };
}
