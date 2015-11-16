{ config, pkgs, ... }:

{
  imports = [
    ./kde5.nix
  ];

  environment.systemPackages = with pkgs; [
    # SSH filesystem via FUSE
    sshfsFuse

    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub

    # editors
    neovim
    vim
      # misc
      vimPlugins.Supertab
      vimPlugins.sensible # 'sensible' defaults
      vimPlugins.vim-addon-completion

      # runtime and configuration management
      vimPlugins.vundle
      vimPlugins.pathogen
      vimPlugins.vim-addon-vim2nix


      # proglang support
      vimPlugins.hasksyn
      vimPlugins.rust


  ];
}
