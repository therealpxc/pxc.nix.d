{ config, pkgs, ... }:
{
  containers.hydra = { config =
    { config, pkgs, ... }:
    {
      # run nixos-15.09 inside the container

      # hydra container config lives in here
      services.ntp.enable = false;
      services.openssh.allowSFTP = false;
      services.openssh.passwordAuthentication = false;

      users = {
        mutableUsers = false;
        users.root.openssh.authorizedKeys.keyFiles = [ "~pxc/.ssh/id_rsa.pub" ];
      };

      imports = [ ../hydra/hydra-module.nix ];

      environment.etc = pkgs.lib.singleton {
        target = "nix/id_buildfarm";
        source = ./id_buildfarm;
        uid = config.ids.uids.hydra;
        gid = config.ids.gids.hydra;
        mode = "0440";
      };

      networking.firewall.allowedTCPPorts = [ config.services.hydra.port ];

      nix = {
        nixPath = [ "nixpkgs=https://github.com/nixos/nixpkgs-channels/archive/nixos-15.09.tar.gz" ];
        distributedBuilds = true;
        useChroot = true;
        buildMachines = [

        ];
        extraOptions = "auto-optimise-store = true";
      };

      services.hydra = {
        enable = true;
        hydraURL = "http://hydra.rex.latitudeengineering.com";
        notificationSender = "hydra@latitudeengineering.com";
        port = 8080;
        extraConfig = "binary_cache_secret_key_file = /etc/nix/hydra.rex.latitudeengineering.com-1/secret";
      };

      services.postgresql = {
        package = pkgs.postgresql94;
        dataDir = "/var/db/postgresql-${config.services.postgresql.package.psqlSchema}";
      };

    };
  };
}
