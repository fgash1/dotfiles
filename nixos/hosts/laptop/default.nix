{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "laptop";

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  environment.systemPackages = [ pkgs.brightnessctl ];
  services.udev.packages = [ pkgs.brightnessctl ];

  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
