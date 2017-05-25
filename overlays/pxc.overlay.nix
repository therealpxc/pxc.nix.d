self: super: {
   vimmy = super.vim_configurable.customize {
     name = "vim";

     vimrcConfig.customRC = ''
     " set vim shell to bash because Syntastic doesn't like fish and stuff
     set shell=/run/current-system/sw/bin/bash
     
     " more fish stuff
     "syntax enable
     "filetype plugin indent on

     " Set up :make to use fish for syntax checking.
     "autocmd FileType fish compiler fish

     " Set this to have long lines wrap inside comments.
     "autocmd FileType fish setlocal textwidth=79

     " Enable folding of block structures in fish.
     "autocmd FileType fish setlocal foldmethod=expr
     
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
            #"Supertab"            # tab completion in insert mode
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
            #"fish-vim" # doesn't work right anyway, need to re-add it to vim-plugin-names &c
            "vim-scala"
            ]; }
     ];
    };

    avahi-compat = super.avahi.override {
      qt4Support = super.avahi.qt4Support or false;
      withLibdnssdCompat = true;
    };

    texLive2016Custom = with super.pkgs; texlive.combine {
      inherit
        (texlive)         # defaults
        scheme-tetex      # ‘bigger than medium, way less than full’
        cm-super          # used in Lyx default document class
        libertine         # Linux Libertine fonts family, my fave
        libertinus        # Linux Libertine fork... maybe awesome?
        libertinust1math  # Linux Libertine fork... maybe awesome?
        preprint          # for fullpage.sty
        enumitem          # for Lyx's ‘Customizable Lists’ module
        graphviz          # for automata and stuff
        newtx             # NewTX math figures + Libertine Math font
        
        #collection-latex
        collection-latexextra     # some NewTX dependency?
        #collection.fontutils
        collection-fontsextra     # for mweight.sty and ???
      ;
    };

    # basic command-line environment
    pxc-common-cli-env = with super.pkgs; buildEnv {
      name = "pxc-common-cli-env";
      paths = [
        # cli basics
        which
        vimmy
        htop
        aria2
        wget
        curl
        
        # stuff my fish config uses
        fish
        grc
        silver-searcher
        sift
        tmux
        python35Packages.powerline
        fzf
        fasd
        mawk                # used by fasd
        xsel                # used by pbcopy
        psmisc              # fuser, killall, pstree & more
        keychain
        direnv              # barebones projects, pretty nifty
        gitAndTools.hub
        gitAndTools.gitFull
        
        # dotfiles & configuration
        home-manager        # rycee's nix-based home manager
        super-user-spark    # dotfiles manager
        pass                # git-based password manager
        pwgen               # for use with pass
        gnupg
        gnupg1
        
        # git
        gitAndTools.gitflow
        gitAndTools.git-annex
        gitAndTools.git-remote-hg

        # filesystem
        p7zip
        fuse-7z-ng
        sshfsFuse
        nfs-utils
        smbnetfs
        fusesmb
        cifs_utils
        
        # other
        weechat             # nice terminal-based IRC app
      ];
    };

    # additional command-line tools and applications
    pxc-common-cli-tools = with super.pkgs; buildEnv {
      name = "pxc-common-cli-tools";
      paths = [
        mediainfo

        # other things I like
        elvish              # cool shell under very active development
        #dvtm              # alternative terminal multiplexer stuff
        #dtach             # related to above
        #abduco            # related to above
        figlet            # stylized ascii-art renderer for text
        cowsay
        telegram-cli
      ];
    };

    pxc-common-gui-apps = with super.pkgs; buildEnv {
      name = "pxc-common-gui-apps";
      paths = [
        firefox
        qtpass              # Qt GUI frontend for pass
        yakuake             # Quake-style terminal
        dolphin             # best file manager ever made
        kdeApplications.dolphin-plugins
        kdeApplications.kio-extras
        kate                # KDE Advanced Text Editor

        # multimedia
        mpv
        vlc
        okular              # document viewer

        # remote desktopery
        x2goclient
        xpra
        winswitch

        # dictionaries
        aspellDicts.en
        hunspellDicts.en-us
      ];
    };
}
