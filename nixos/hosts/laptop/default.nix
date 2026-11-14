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

  # 15.6" 1080p panel is ~141 DPI; 110 keeps text readable without oversizing bars and web pages
  services.xserver.dpi = 110;
  home-manager.users.fatjon.xresources.properties."Xft.dpi" = 110;
  home-manager.users.fatjon.xdg.configFile."alacritty-host.toml".text = ''
    [font]
    size = 11
  '';

  system.stateVersion = "26.05";
}
