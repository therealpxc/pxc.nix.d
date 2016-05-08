{ config, pkgs, stdenv, ... }:
#with import <nixpkgs>;

{
  environment.systemPackages = with pkgs; [
    vimmy
  ];
  
  nixpkgs.config.packageOverrides = pkgs: rec {  
   vimmy = pkgs.vim_configurable.customize {
       name = "vim";

       vimrcConfig.customRC = ''
       " set vim shell to bash because Syntastic doesn't like fish and stuff
       set shell=/run/current-system/sw/bin/bash
       
       " hybrid line numbering: absolute for current, relative for others
       set relativenumber
       set number


       " tab width is 2, replace tabs with 2 spaces each
       set tabstop=2
       set expandtab
       set shiftwidth=2
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

    # needed for px4
    empy = pkgs.pythonPackages.buildPythonPackage rec {
      version = "3.3.2";
      
      name = "empy-${version}";
      
      src = pkgs.fetchurl {
        url = "https://pypi.python.org/packages/source/E/EmPy/${name}.tar.gz";
        sha256 = "177avx6iv9sq2j2iak2il5lxqq0k4np7mpv5gasqmi3h4ypidw4r";
      };

      meta = with stdenv.lib; {
        description = "A powerful and robust templating system for Python.";
        homepage = "https://pypi.python.org/pypi/EmPy";
        license = licenses.lgpl2;
        maintainers = [ pxc ];
      };
    };


    avahi-compat = pkgs.callPackage ../nixpkgs/pkgs/development/libraries/avahi {
      qt4Support = config.avahi.qt4Support or false;
      withLibdnssdCompat = true;
    };
  };
}

