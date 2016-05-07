{ config, pkgs, ... }:

{
  imports = [ ./desktop.nix ];

  services.xserver.desktopManager.kodi.enable = true;
  environment.systemPackages = with pkgs; [
    kodiPlugins.pdfreader
    kodiPlugins.steam-launcher
    kodiPlugins.urlresolver
    kodiPlugins.advanced-launcher
    #kodiPlugins.salts  # (removed from github)

    # TV streaming through TV headend
    tvheadend
    kodiPlugins.pvr-hts

    steam
  ];

  # 32-bit support for WINE and Steam games
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs; [
    libvdpau-va-gl
    vaapiVdpau
    vaapiIntel
    libvdpau
    libva
  ];
}
