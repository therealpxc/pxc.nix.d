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

    # mediainfo and mplayer included in profiles/elements/common.nix
    # mediainfo mplayer
    vlc
    mpv

    # TV streaming (integrates w/ Kodi through pvr-hts)
    tvheadend

    steam
    playonlinux   # wine frontend

    # aggregate emulator frontend; ROM library browser and manager
    emulationstation

    # modular game console emulator + backends
    retroarch

    # misc emulators
    mupen64plus
    #wxmupen64plus     # broken as of 2016-05-07
    pcsx2
    higan
    fceux
    zsnes
    snes9x-gtk
    gensgs
    yabause
    atari800
    hatari
    ataripp
    stella
    dolphinEmuMaster
    #mess           # appears broken as of 2016-05-07
    residualvm      # LucasArts adventure games
    
    # hardware peripheral drivers and services
    cwiid
    xwiimote
    xboxdrv
    python27Packages.ds4drv
    qjoypad
    #antimicro      # broken as of 2016-05-07

    # games & toys
    game-music-emu
    freedink        # Dink Smallwood!
    hawkthorne      # Community game!
    kde4.ksirk      # Risk
    n2048
    openmw          # Morrowind
    openra          # Command & Conquer: Red Alert
    superTux
    wesnoth
    widelands
    warzone2100
    xonotic

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

  services.xserver.vaapiDrivers = with pkgs; [ vaapiIntel vaapiVdpau vaapiIntel libvdpau libva libvdpau-va-gl ];

}
