{ pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;
    windowManager.i3.enable = true;
    xkb.layout = "us";
    inputClassSections = [
      ''
        Identifier "keyboard-repeat"
        MatchIsKeyboard "on"
        Option "AutoRepeat" "300 16"
      ''
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  programs.dconf.enable = true;
  programs.firefox.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.sauce-code-pro
    source-code-pro
    noto-fonts
    dejavu_fonts
    font-awesome
    freefont_ttf
    wqy_microhei
  ];
}
