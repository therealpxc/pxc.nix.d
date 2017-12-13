{ config, pkgs, ... }:

{
  imports = [
    ./desktop.nix
  ];


  environment.systemPackages = with pkgs; [
    lighttable              # lighttable editor
    leiningen               # Clojure project + dependency manager
    glxinfo
    atom
    scala     # scala (2.12.2 as of 2017-05-14)
    scalafmt  # scala formatter
    sbt       # ‘scala build tool’

    virtmanager
    jdk     # openjdk 8

    # python development tools
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
