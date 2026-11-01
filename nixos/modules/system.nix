{ pkgs, ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Skopje";

  zramSwap.enable = true;
  services.fstrim.enable = true;
  hardware.bluetooth.enable = true;
  hardware.uinput.enable = true;

  virtualisation.docker.enable = true;

  programs.ssh = {
    startAgent = true;
    agentTimeout = "8h";
  };

  # Lets prebuilt Linux binaries (e.g. the native claude installer) find a dynamic loader
  programs.nix-ld.enable = true;

  programs.fish.enable = true;
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  users.users.fatjon = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "input"
      "uinput"
      "video"
    ];
  };
}
