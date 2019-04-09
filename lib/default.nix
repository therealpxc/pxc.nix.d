# To interact with this file:
# nix-repl lib.nix
{ pkgs, ... }:
let
  # Allow overriding pinned nixpkgs for debugging purposes via iohkops_pkgs
  fetchNixpkgs = import ./fetch-nixpkgs.nix;

  lib = pkgs.lib;
in lib // (rec {
  inherit fetchNixpkgs;
})
