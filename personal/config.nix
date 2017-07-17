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
  
  packageOverrides = super: let self = super.pkgs; in with pkgs; {
    elvish = super.elvish.overrideAttrs (oldAttrs: rec {
      name = "elvish-git";
      src = super.fetchFromGitHub {
        repo = "elvish";
        owner = "therealpxc";
        rev = "66b7f997f7e5ff32eaa288be3769f9211762f3b7";
        sha256 = "03id8h643xkk707qivss9m74q4gsdz2nrcz4hy2axq0989qsl04y";
      };
    });
  };
}
