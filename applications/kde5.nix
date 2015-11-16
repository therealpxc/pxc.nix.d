# based upon Corey O'Connor's kde5.nix
{ config, pkgs, lib, ... }: with lib;
{
  services.xserver.desktopManager.kde5 =
  {
    enable = true;
    phonon.gstreamer.enable = true;
  };
  services.xserver.displayManager.slim.enable = true;
  nixpkgs.config.packageOverrides = in_pkgs : rec
  {
      # otherwise packages dependent on qt4 pull in entire KDE workspace.
      qt4 = in_pkgs.qt48;
  };
}
