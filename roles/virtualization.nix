{ config, pkgs, ... }:

{
  boot.enableContainers = true;
  services.nfs.server.enable = true;
  virtualisation.virtualbox.host.enable = true;
 # virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.lxc.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    vagrant
    # virtualbox
  ];
}
