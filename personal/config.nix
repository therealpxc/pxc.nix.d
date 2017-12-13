pkgs :

{
  allowUnfree = true;

  nix.nixPath = [ "nixpkgs=../pkgsets/nixpkgs/nixpkgs" ];

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };

}
