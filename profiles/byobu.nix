{ config, pkgs, lib, ...}:

{

  # this definitely does not work right now
  # basic-ass infinite recursion ftl; will replace
  packageOverrides = {
    byobu = lib.overrideDerivation pkgs.byobu (attrs: rec {
      name = "byobu-full";
      buildInputs = [ pkgs.tmux pkgs.snack ];
    });
    
  };
    
  environment.systemPackages = with pkgs; [
  ];
}
