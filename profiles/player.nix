{ config, pkgs, ... }:

let
  kodiPlugins = with pkgs.kodiPlugins; [
    pdfreader steam-launcher urlresolver advanced-launcher pvr-hts
  ];
  
  retroPlugins = with pkgs.libretro; [
    _4do
    bsnes-mercury
    desmume
    fba
    fceumm
    gambatte
    genesis-plus-gx
    genesis-plus-gx
    mednafen-pce-fast
    mupen64plus
    nestopia
    picodrive
    ppsspp
    quicknes
    scummvm
    snes9x
    snes9x-next
    stella
    vba-next
    vba-m
  ];
in 
{
  imports = [ ./desktop.nix ];

  services.xserver.desktopManager.kodi.enable = true;
  programs.cdemu.enable = true;


  environment.systemPackages = with pkgs; [
    kodi

    # TV streaming (integrates w/ Kodi through pvr-hts)
    tvheadend

    steam
    playonlinux   # wine frontend

    # aggregate emulator frontend; ROM library browser and manager
    emulationstation

    # modular game console emulator + backends
    retroarch

  ] ++ kodiPlugins ++ retroPlugins;

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
