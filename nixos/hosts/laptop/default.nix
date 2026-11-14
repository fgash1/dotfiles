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

    xdg.configFile."libinput-gestures.conf".text = ''
      gesture swipe left 3 xdotool key alt+Right
      gesture swipe right 3 xdotool key alt+Left
    '';
    systemd.user.services.libinput-gestures = {
      Unit.Description = "Touchpad gestures";
      Service = {
        ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures";
        Environment = [
          "DISPLAY=:0"
          "XAUTHORITY=%h/.Xauthority"
        ];
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };

  system.stateVersion = "26.05";
}
