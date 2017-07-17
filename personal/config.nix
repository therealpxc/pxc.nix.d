pkgs :

{
  allowUnfree = true;
  virtualbox = { enableExtensionPack = true; };

  nix.nixPath = [ "nixpkgs=../channels/nixpkgs" ];

  firefox = {
    enableGoogleTalkPlugin = true;
    enableAdobeFlash = true;
  };

  chromium = {
    enablePepperFlash = true;
    enablePepperPDF = true;
  };
}
