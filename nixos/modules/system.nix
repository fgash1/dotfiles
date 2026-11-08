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

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  security.sudo.extraConfig = ''
    Defaults timestamp_timeout=30
    Defaults timestamp_type=global
  '';

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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwetI0mnb/fs/tX4a0N0v3RI4julS75nm+TGPyImyEX fatjon@laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICfGZxg7vtZdz2MeunLJNBZ2jNPRJzP48flQTQbMhJz4 fatjon@desktop"
    ];
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
