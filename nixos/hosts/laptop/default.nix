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
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    # Firefox on X11 only gets smooth touchpad scrolling and pinch-zoom through XInput2, which is opt-in
    MOZ_USE_XINPUT2 = "1";
  };

  environment.systemPackages = [ pkgs.brightnessctl ];
  services.udev.packages = [ pkgs.brightnessctl ];

  services.thermald.enable = true;

  services.libinput.touchpad = {
    disableWhileTyping = true;
    naturalScrolling = true;
  };
  # Typing reaches libinput through kanata's virtual keyboard, which it only pairs with the touchpad if marked internal
  environment.etc."libinput/local-overrides.quirks".text = ''
    [kanata virtual keyboard]
    MatchName=kanata
    AttrKeyboardIntegration=internal
  '';

  # 15.6" 1080p panel is ~141 DPI; 110 keeps text readable without oversizing bars and web pages
  services.xserver.dpi = 110;

  home-manager.users.fatjon = {
    xresources.properties."Xft.dpi" = 110;
    xdg.configFile."alacritty-host.toml".text = ''
      [font]
      size = 11
    '';
  };

  system.stateVersion = "26.05";
}
