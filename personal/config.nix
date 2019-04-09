pkgs :

{
  allowUnfree = true;

  # nix.nixPath = [ "nixpkgs=../pkgsets/nixpkgs/nixpkgs" ];

  android_sdk.accept_license = true;

  firefox = {
    enableGoogleTalkPlugin = true;
    enablePlasmaBrowserIntegration = true;
    enableBrowserpass = true;
    #   enableAdobeFlash = true;
  };

  # chromium = {
  # #    enablePepperFlash = true;
  #   # enablePepperPDF = true;
  # };

  php.xslSupport = true;

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };


}
