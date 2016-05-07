{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./desktop.nix
      ./elements/virtualization.nix
    ];

  services.xserver.windowManager.i3.enable = true;

  environment.systemPackages = with pkgs; [
    lighttable          # lighttable editor
    leiningen           # Clojure project + dependency manager
    glxinfo
    atom
    i3                  # TODO: figure out how I want to integrate i3 and kde5
    eclipses.eclipse_sdk_451
    dwm
    i3status
    dmenu
    virtmanager
    jdk     # openjdk 8
    jdk7    # openjdk 7


  ];
}