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

  # ansible19 = super.ansible.overrideAttrs (oldAttrs: rec {
  #   name = "ansible-${version}";
  #   version = "1.9.5";

  #   src = super.fetchurl {
  #     url = "http://releases.ansible.com/ansible/ansible-${version}.tar.gz";
  #     sha256 = "13mxri6i5wkp3bql0q0803wsy226l21yxd0fxadhi4yrk2fm78vb";
  #   };
  # });

  # basic command-line environment, common to all platforms
  pxc.common.tui.pkgs = with self.pkgs; [
    # cli basics
    which
    htop
    aria2
    wget
    curl
    httpie                    # fancier curl?
    ranger    # file manager
    ripgrep
    tree
    fpp       # facebook path picker

    # nix tools
    nix-repl
    nixops
    #disnix

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
    gitAndTools.tig     # curses TUI for browsing git logs
    pythonPackages.powerline
    findutils           # macOS comes with weak find command
    # commented out because it's not in Nixpkgs yet
    #chips               # an alternative to oh-my-fish
    #thefuck             # correct mistaken commands
    gawk                # macOS comes with ancient gawk, tmux-fingers wants a newer one

    # dotfiles & configuration
    #home-manager        # rycee's nix-based home manager
    super-user-spark    # dotfiles manager
    pass                # git-based password manager
    pwgen               # for use with pass

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

    sbt-with-scala-native
    graphicsmagick
  ];
  pxc.common.tui.env = with self.pkgs; buildEnv {
    name = "pxc-common-tui-env";
    paths = pxc.common.tui.pkgs;
  };


  pxc.common.gui.pkgs = with self.pkgs; [
    # use the GNU Emacs distribution on both Linux and Mac
    emacs


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

    gnupg               # macOS comes with old GPG, so the gpg-agent is old and bad

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

    gnome3.cheese            # simple GNOME webcam app

    ######
    # packages below should ideally be in common.gui.pkgs, but some need to be
    # fixed or recreated for Darwin compatibility
    #

    # chat apps
    slack
    discord

    firefox
    dolphin             # best file manager ever made
    kdeApplications.dolphin-plugins
    kdeApplications.kio-extras
    kate
    yakuake             # Quake-style terminal
    ark
    krita
    vlc
    okular              # document viewer

    # remote desktopery
    x2goclient
    winswitch

    # multimedia
    mpv

    qtpass              # Qt GUI frontend for pass -- qtbase-opensource is broken on macOS

    # dependency hddtemp doesn't build on Darwin
    pythonPackages.glances  # fancier htop?
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

    # we need old GPG because macOS sucks
    gnupg20
  ];
  pxc.macos.tui.env = with super.pkgs; buildEnv {
    name = "pxc-macos-tui-env";
    paths = pxc.macos.tui.pkgs;
  };

  pxc.macos.gui.pkgs = with self.pkgs; [
    #iterm2
    sequelpro

    # not sure if these are necessary. I should do this a better way
    powerline-fonts
    source-code-pro

    # this doesn't let me connect terminal emacsclient to GUI Emacs
    # emacs25Macport
  ];
  pxc.macos.gui.env = with super.pkgs; buildEnv {
    name = "pxc-macos-gui-env";
    paths = pxc.macos.gui.pkgs;
  };
}
