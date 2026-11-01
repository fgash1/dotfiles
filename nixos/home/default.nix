{
  config,
  lib,
  pkgs,
  ...
}:
let
  repo = "${config.home.homeDirectory}/dotfiles";

  # links.Linux stays the single source of truth; sudo (/etc) entries are handled by NixOS modules.
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
