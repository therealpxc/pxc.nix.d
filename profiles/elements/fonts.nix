# Patrick's preferred font configuration, inspired by the various configuration
# examples available on github and collected as submodules in my github repo
# therealpxc/nixos-include, especially grwlf's fonts.nix & 7c6f434c's fonts.nix

{ config, pkgs, ... } :
{
    fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      # microsoft & microsoft-compatibility
      vistafonts
      liberation_ttf
      comic-neue
      carlito

      # general-purpose
      ttf_bitstream_vera
      dejavu_fonts
      ubuntu_font_family

      # extended unicode & special
      symbola
      clearlyU
      unifont
      freefont_ttf
      cm_unicode
      ucsFonts
      junicode


      # terminal & coding, monospace
      inconsolata
      dosemu_fonts
      anonymousPro

      # tex & typesetting
      (pkgs.ghostscript + "/share/ghostscript/fonts/")
      stix-otf
      xorg.fontadobe100dpi
      xorg.fontadobe75dpi
      xorg.fontadobeutopia100dpi
      xorg.fontadobeutopia75dpi
      xorg.fontadobeutopiatype1
      lmmath
      lmodern

      hasklig
      powerline-fonts
    ];
  };
}
