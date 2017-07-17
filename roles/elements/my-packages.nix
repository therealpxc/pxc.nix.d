{ config, pkgs, stdenv, ... }:

{
  nixpkgs.overlays = [
    (import ../../overlays/pxc.overlay.nix)
    (self: super: {
      home-manager = import ../../pkgs/home-manager { inherit pkgs; };
      sbtix = super.callPackage ../../pkgs/Sbtix/sbtix-tool.nix { };
    })
  ];
}
