{ config, pkgs, ...}:

{
#  nixpkgs.config.nixPath = config.nixPath ++ [ "/root/.nix-defexpr/channels/nixdev" ];
  nix.nixPath = [ "/etc/nixos" "nixos-config=/etc/nixos/configuration.nix" ];
  environment.extraInit = ''
    EDITOR=vim
  '';

  nixpkgs.config.packageOverrides = {
   vimmy = pkgs.vim_configurable.customize {
       name = "vim";

       vimrcConfig.customRC = ''
       " set vim shell to bash because Syntastic doesn't like fish and stuff
       set shell=/run/current-system/sw/bin/bash
       set number
       set tabstop=2
       '';
       #vimrcConfig.vam.knownPlugins = pkgs.vimPlugins; # optional
       #vimrcConfig.vam.knownPlugins = pkgs.vimPlugins ++ mypkgs.pkgs.vimPlugins; # optional
       vimrcConfig.vam.pluginDictionaries = [
         {  names = [
              "vim2nix"
              "sensible"            # sensible defaults
              "vim-addon-nix"       # vim syntax checking for .nix files
              "YouCompleteMe"       # better? autocompletion
              "Syntastic"           # syntax checking
              "ctrlp"               # fuzzy finder
              "Tabular"             # alignment guides
              "Supertab"            # tab completion in insert mode
              "vim-gitgutter"       # mark changed lines since last commit with a clear visual indicator in the gutter
              "fugitive"            # some kind of fancy git thing!
              "UltiSnips"           # fancy snippets
              "VimOutliner"         # vim outlining; collapse/expand trees like a cool kid
              "vim-webdevicons"     # cool unicode glyphage
              #"fireplace"       # Clojure REPL!
              #"VimClojure"          # Clojure support for vim!
              #"drgnbrg/vim-redl"    # repl debugging
              #"ag"
              #"gitv"
              "tmux-navigator"
              ]; }
       ];
    };
    
#    avahi = pkgs.callPackage ../nixpkgs/pkgs/development/libraries/avahi {
#      qt4Support = config.avahi.qt4Support or false;
#      withLibdnssdCompat = true;
#    };
  };
  
  environment.systemPackages = with pkgs; [
    vimmy
    xpra              # in desktop.profile we also include winswitch
    p7zip
    utillinuxCurses   # used by oh-my-fish
  ];
}
