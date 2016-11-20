{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./desktop.nix
      ./elements/virtualization.nix
    ];

  services.xserver.windowManager.i3.enable = true;
  
  # for communityshare research for now
  services.elasticsearch.enable = true;
  services.elasticsearch.plugins = with pkgs; [
    # web admin interface
    #elasticsearchPlugins.elasticsearch_kopf # I think these are only for old elasticsearch

    # lemmatization (stemming, grouping inflected words with the same base)
    #elasticsearchPlugins.elasticsearch_analisys_lemmagen # broken? 2016-06-08
  ];

  services.postgresql.enable = true;

  environment.systemPackages = with pkgs; [
    lighttable              # lighttable editor
    leiningen               # Clojure project + dependency manager
    glxinfo
    atom
    i3                      # TODO: figure out how I want to integrate i3 and kde5
    eclipses.eclipse_sdk_451
    dwm
    i3status
    dmenu
    virtmanager
    jdk     # openjdk 8
    jdk7    # openjdk 7

    # python development tools
    python3
    python35Packages.pew
    python35Packages.virtualenv
    idea.pycharm-community

    # misc dev tools
    direnv

    # typesetting tools
    texLive2016Custom       # defined in ../elements/my-packages.nix using texLiveAggregationFun
    lyx
    graphviz
    ghostscript
  ];
}
