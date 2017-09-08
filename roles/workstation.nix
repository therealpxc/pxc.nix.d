{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
    ./virtualization.nix
  ];

  programs.adb.enable = true;
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
  programs.mosh.enable = true;
  
  environment.systemPackages = with pkgs; [
    adb-sync
    (heimdall.overrideAttrs (oldAttrs: rec {
      withGUI = true;
    }))

    lighttable              # lighttable editor
    leiningen               # Clojure project + dependency manager
    glxinfo
    atom
    eclipses.eclipse-sdk
    #eclipses.eclipse-scala-sdk # based on Eclipse 4.4.1
    scala     # scala (2.12.2 as of 2017-05-14)
    scalafmt  # scala formatter
    sbt       # ‘scala build tool’

    virtmanager
    jdk     # openjdk 8

    # python development tools
    python3
    python35Packages.pew
    python35Packages.virtualenv

    # misc dev tools
    direnv

    # typesetting tools
    #texLive2016Custom       # defined in ../elements/my-packages.nix using texLiveAggregationFun
    lyx
    graphviz
    ghostscript
  ];
}
