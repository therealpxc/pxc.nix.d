{ config, pkgs, ... }:
{
  # hydra config here
  services.ntp.enable = false;
  services.openssh.allowSFTP = false;
  services.openssh.passwordAuthentication = false;

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keyFiles = [ "~pxc/.ssh/id_rsa.pub" "~hydra/.ssh/id_rsa.pub" ];
  };

  imports = [ ../hydra/hydra-module.nix ];

  networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

  nix = {
    nixPath = [ "nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-16.03-beta.tar.gz" ];
    distributedBuilds = true;
    useChroot = true;
    extraOptions = "auto-optimise-store = true";
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://hydra.rex.latitudeengineering.com";
    notificationSender = "hydra@latitudeengineering.com";
    listenHost = "0.0.0.0";
    port = 8080;
    extraConfig = "binary_cache_secret_key_file = /etc/nix/hydra.rex.latitudeengineering.com-1/secret";
  };

  services.postgresql = {
    package = pkgs.postgresql94;
    dataDir = "/var/db/postgresql-${config.services.postgresql.package.psqlSchema}";
  };
}
