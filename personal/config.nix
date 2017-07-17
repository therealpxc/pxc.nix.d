pkgs :

{
  allowUnfree = true;
  virtualbox = { enableExtensionPack = true; };
  gazebo = { withQuickBuild = true; };

  #  nix.nixPath = [ "nixup-config=/home/pxc/.config/nixup/profile.nix" ];
  #  nix.nixPath = [ "~/Code/Personal" ];

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
        rev = "8556834802f5629ed4e8f8e65dc8e030a104acc1";
        sha256 = "0xpfjficwq261yag9hrxx6mbl97rv0zmp1cllfvyc160x4v0y115";
      };
    });
  };
}
