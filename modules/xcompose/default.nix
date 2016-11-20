{ config, lib, ... }: with lib;
{
  config.environment = mkIf config.services.xserver.enable {
    etc.XCompose.source = ./pointless-extended.xcompose;
    variables.GTK_IM_MODULE = "xim";
    variables.QT4_IM_MODULE = "xim";

    # xim is an alias to compose with qt5
    variables.QT_IM_MODULE = "compose";
    variables.XCOMPOSEFILE = "/etc/XCompose";
  };
}
