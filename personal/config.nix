pkgs :

{
  allowUnfree = true;

  nix.nixPath = [ "nixpkgs=../pkgsets/nixpkgs/nixpkgs" ];

  firefox = {
    enableGoogleTalkPlugin = true;
    #   enableAdobeFlash = true;
  };

  chromium = {
  #    enablePepperFlash = true;
    enablePepperPDF = true;
  };

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


}
