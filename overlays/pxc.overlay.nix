self: super: {
  pxc.vimrcConfig = {
    customRC = ''
      " set vim shell to bash because Syntastic doesn't like fish and stuff
      set shell=/run/current-system/sw/bin/bash

      colorscheme behelit

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

      " tell airline to use powerline fonts
      let g:airline_powerline_fonts = 1
      let g:airline_theme = 'behelit'
      let g:airline#extensions#tabline#enabled = 1

      " tmux-navigator
      let g:tmux_navigator_no_mappings = 1

      nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
      nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
      nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
      nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
      nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
    '';

    packages.thisPackage.start = with self.vimPlugins; [ vim-nix ];
    vam.pluginDictionaries = [
      {  names = [
          "vim2nix"
          "sensible"            # sensible defaults
          "YouCompleteMe"       # better? autocompletion
          "Syntastic"           # syntax checking
          "ctrlp"               # fuzzy finder
          "Tabular"             # alignment guides
          "Supertab"            # tab completion in insert mode
          "vim-gitgutter"       # mark changed lines since last commit with a clear visual indicator in the gutter
          "fugitive"            # some kind of fancy git thing!
          "UltiSnips"           # fancy snippets
          "VimOutliner"         # vim outlining; collapse/expand trees like a cool kid
          #"vim-webdevicons"     # cool unicode glyphage
          #"fireplace"       # Clojure REPL!
          #"VimClojure"          # Clojure support for vim!
          #"drgnbrg/vim-redl"    # repl debugging
          #"ag"
         #"gitv"
          "tmux-navigator"

          "vim-scala"

          "vim-airline"
          "vim-airline-themes"
          "vim-colorschemes"
        ];
      }
    ];
  };

  elvish = super.elvish.overrideAttrs (oldAttrs: rec {
    name = "elvish-git";
    src = super.fetchFromGitHub {
      repo = "elvish";
      owner = "therealpxc";
      rev = "66b7f997f7e5ff32eaa288be3769f9211762f3b7";
      sha256 = "03id8h643xkk707qivss9m74q4gsdz2nrcz4hy2axq0989qsl04y";
    };
  });

  neovimmy = super.neovim.override (o: {
    configure = self.pxc.vimrcConfig // {
      vam.pluginDictionaries = self.pxc.vimrcConfig.vam.pluginDictionaries ++ [
        { name = "ensime-vim"; }
      ];
    };
    vimAlias = false;
  });

  vimmy = super.vim_configurable.customize {
    name = "vim";

    vimrcConfig = self.pxc.vimrcConfig;
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

  ranger = super.ranger.overrideAttrs (oldAttrs: {
    name = "ranger-1.9.0b5";
  });

  # basic command-line environment, common to all platforms
  pxc.common.tui.pkgs = with self.pkgs; [
    # cli basics
    which
    htop
    aria2
    wget
    curl
    ranger    # file manager
    ripgrep
    tree
    fpp       # facebook path picker

    # nix tools
    nix-repl
    nixops
    disnix

    # fancy vim
    neovimmy
    vimmy
    unzip               # for using vim to explore zip files

    # this is python with the required deps for vim and Spacemacs
    (python3.withPackages (ps: with ps; [ sexpdata websocket_client ]))

    # stuff my fish config uses and some goodies I want
    fish
    grc
    silver-searcher
    sift
    tmux
    byobu
    fzf
    fasd
    mawk                # used by fasd
    xsel                # used by pbcopy
    keychain
    direnv              # barebones projects, pretty nifty
    gitAndTools.hub
    gitAndTools.gitFull
    pythonPackages.powerline
    findutils           # macOS comes with weak find command

    # dotfiles & configuration
    #home-manager        # rycee's nix-based home manager
    super-user-spark    # dotfiles manager
    pass                # git-based password manager
    pwgen               # for use with pass
    gnupg
    gnupg1

    # git
    gitAndTools.gitflow
    gitAndTools.git-remote-hg

    # filesystem
    p7zip

    # other
    weechat             # nice terminal-based IRC app

    # possibly useful for work remote debugging stuff?
    unison
    fswatch

    ### extras-ish ###
    mediainfo
    asciinema

    # other things I like
    #dvtm              # alternative terminal multiplexer stuff
    #dtach             # related to above
    #abduco            # related to above
    cowsay

    # just for funsies
    bashInteractive
    zsh
  ];
  pxc.common.tui.env = with self.pkgs; buildEnv {
    name = "pxc-common-tui-env";
    paths = pxc.common.tui.pkgs;
  };


  pxc.common.gui.pkgs = with self.pkgs; [
    firefox
    qtpass              # Qt GUI frontend for pass
    yakuake             # Quake-style terminal
    dolphin             # best file manager ever made
    kdeApplications.dolphin-plugins
    kdeApplications.kio-extras
    kate                # KDE Advanced Text Editor
    ark
    krita

    # multimedia
    mpv
    vlc
    okular              # document viewer

    # remote desktopery
    x2goclient
    winswitch

    # dictionaries
    aspellDicts.en
    hunspellDicts.en-us
  ];
  pxc.common.gui.env = with super.pkgs; buildEnv {
    name = "pxc-common-tui-env";
    paths = pxc.common.gui.pkgs;
  };

  # Linux-only packages which require only a textual user-interface
  pxc.linux.tui.pkgs = with self.pkgs; [
    fuse-7z-ng
    sshfsFuse
    nfs-utils
    smbnetfs
    fusesmb
    cifs_utils

    # this needs to be fixed... python cffi doesn't build with clang

    pdfgrep
    pdftk
    gitAndTools.git-annex
    lshw
    psmisc              # fuser, killall, pstree & more
    usbutils

    # elvish doesn't build on macOS because of some detected cycle.
    # it's a common problem for macOS Go packages and there are
    # known fixes.
    elvish              # cool shell under very active development
  ];
  pxc.linux.tui.env = with super.pkgs; buildEnv {
    name = "pxc-linux-tui-env";
    paths = pxc.linux.tui.pkgs;
  };

  pxc.linux.gui.pkgs = with self.pkgs; [
    # X utilities
    xorg.xmodmap
    xpra

    gnome3.cheese              # simple GNOME webcam app

    # chat apps
    slack
    discord
    
    # for spacemacs!
    # (added separately here so that I can specify the Mac port on macOS)
    emacs
  ];
  pxc.linux.gui.env = with super.pkgs; buildEnv {
    name = "pxc-linux-gui-env";
    paths = pxc.linux.gui.pkgs;
  };

  pxc.macos.tui.pkgs = with self.pkgs; [
    # needed for tmux and possibly other utilities to work right
    # (used by `open` command)
    reattach-to-user-namespace

    # I hate non-GNU coreutils
    coreutils
  ];
  pxc.macos.tui.env = with super.pkgs; buildEnv {
    name = "pxc-macos-tui-env";
    paths = pxc.macos.tui.pkgs;
  };

  pxc.macos.gui.pkgs = with self.pkgs; [
    iterm2
    sequelpro

    # not sure if these are necessary. I should do this a better way
    powerline-fonts
    source-code-pro

    emacs25Macport
  ];
  pxc.macos.gui.env = with super.pkgs; buildEnv {
    name = "pxc-macos-gui-env";
    paths = pxc.macos.gui.pkgs;
  };
}
