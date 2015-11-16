# compilers and SCMs go here
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # version control
    gitAndTools.gitFull
    gitAndTools.gitflow
    gitAndTools.hub

    # compilers
    gcc_multi
    gccgo
    clang_35
    llvm_35
    ghc
      cabal2nix


    # dynamic languages
    ruby
      chruby
      bundler
  # python
      python27Packages.python
      python34Packages.python
      python34Packages.virtualenvwrapper
      # pure python virtualenvwrapper rewrite
      python34Packages.pew
      egg2nix
      python2nix
      pypi2nix
    nodejs
      npm2nix

  ];
}
