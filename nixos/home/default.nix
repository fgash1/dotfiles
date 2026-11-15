{
  config,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/dotfiles";

  links = lib.pipe (builtins.readFile ../../links.Linux) [
    (lib.splitString "\n")
    (map (line: lib.filter (s: builtins.isString s && s != "") (builtins.split "[[:space:]]+" line)))
    (lib.filter (f: f != [ ] && !lib.hasPrefix "#" (lib.head f) && lib.length f == 2))
  ];
in
{
  home.stateVersion = "26.05";

  home.file = lib.listToAttrs (
    map (f: {
      name = lib.removePrefix "~/" (lib.elemAt f 1);
      value.source = config.lib.file.mkOutOfStoreSymlink "${repo}/${lib.head f}";
    }) links
  );

  # Claude Code saves via temp file + rename next to the first symlink hop, which fails inside /nix/store.
  home.activation.claudeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    run mkdir -p $HOME/.claude
    run ln -sfn ${repo}/.claude/settings.json $HOME/.claude/settings.json
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      lib.genAttrs [
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/chrome"
        "text/html"
        "application/xhtml+xml"
        "application/x-extension-htm"
        "application/x-extension-html"
        "application/x-extension-shtml"
        "application/x-extension-xhtml"
        "application/x-extension-xht"
      ] (_: "firefox.desktop")
      // {
        "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      };
  };

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    theme = {
      name = "Arc-Dark";
      package = pkgs.arc-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  systemd.user.services.kanata = {
    Unit.Description = "Kanata keyboard remapper";
    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg %h/.config/kanata/kanata.kbd --no-wait";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
