{ config, pkgs, ... }:

{
  # 32-bit support for WINE and Steam games
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau
    libva
    libvdpau-va-gl
  ];
  hardware.opengl.extraPackages32 = config.hardware.opengl.extraPackages;

  hardware.pulseaudio.support32Bit = true;

  environment.systemPackages = with pkgs; [ steam steam-run ];

}
