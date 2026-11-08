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

  services.autorandr.enable = true;

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
  programs.firefox = {
    enable = true;
    preferencesStatus = "default";
    preferences = {
      "browser.aboutConfig.showWarning" = false;
      "browser.compactmode.show" = true;
      "browser.uidensity" = 1;
      "browser.theme.toolbar-theme" = 0;
      "layout.css.prefers-color-scheme.content-override" = 0;
      "browser.toolbars.bookmarks.visibility" = "always";
      "browser.bookmarks.showMobileBookmarks" = false;
      "browser.newtabpage.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.preferences.defaultPerformanceSettings.enabled" = false;
      "browser.translations.alwaysTranslateLanguages" = "nl";
      "general.autoScroll" = true;
      "ui.key.menuAccessKeyFocuses" = false;
      "accessibility.typeaheadfind.enablesound" = false;
      "media.eme.enabled" = true;
      "network.prefetch-next" = false;
      "network.http.speculative-parallel-limit" = 0;
      "privacy.clearOnShutdown_v2.formdata" = true;
      "privacy.clearOnShutdown_v2.downloads" = false;
    };
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  fonts.fontconfig.defaultFonts.monospace = [ "SauceCodePro Nerd Font" ];
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
