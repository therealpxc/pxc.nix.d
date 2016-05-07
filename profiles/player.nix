{ config, pkgs, ... }:

{
  imports = [ ./elements/desktop.nix ];

  services.xserver.desktopManager.kodi.enable = true;
  environment.systemPackages = [
    kodiPlugins.pdfreader
    kodiPlugins.steam-launcher
    kodiPlugins.urlresolver
    kodiPlugins.advanced-launcher
    kodiPlugins.salt

    # TV streaming through TV headend
    tvheadend
    kodiPlugins.pvr-hts

    steam
  ];

  # 32-bit support for WINE and Steam games
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs; [
    libvdpau-va-gl
    libva-vdpau-driver
    libva-intel-driver
    libvdpau
    libva
  ];
}
