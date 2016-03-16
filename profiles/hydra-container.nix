{ config, pkgs, ... }:
{

  #users.extraUsers = {
  #    hydra = { extraGroups = [ "hydra" ]; };
  #    hydra-queue-runner = { extraGroups = [ "hydra" ]; };
  #};

#  nix.trustedUsers = [ "@hydra" ];

  containers.chydra = {
    config = import ./hydra.nix;
    # more container options
    autoStart = true;   # run the container when the host system boots
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
  };

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["ve-+"];
  networking.nat.externalInterface = "enp0s31f6";
}
