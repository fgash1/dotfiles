{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "desktop";

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/56163e61-ee52-49bf-b592-97ed3a564ae4";
    fsType = "ext4";
  };

  boot.kernelParams = [
    "ipv6.disable=1"
    "zswap.enabled=0"
  ];
  networking.enableIPv6 = false;

  # GTX 1050 is Pascal, which the 590+ drivers dropped
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
    open = false;
    modesetting.enable = true;
    powerManagement.enable = true;
  };
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [ pkgs.nvidia-vaapi-driver ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };
  programs.firefox.preferences = {
    "browser.download.dir" = "/data/Downloads";
    "browser.download.folderList" = 2;
    "media.ffmpeg.vaapi.enabled" = true;
    "media.av1.enabled" = false;
    "gfx.x11-egl.force-enabled" = true;
    "widget.dmabuf.force-enabled" = true;
  };

  # In-kernel rtw88 keeps dropping this card, even with deep LPS and ASPM disabled
  # With power saving on, the card stops answering ARP and drops off the LAN
  networking.networkmanager.wifi.powersave = false;
  boot.extraModulePackages = [ (config.boot.kernelPackages.callPackage ./rtl8821ce.nix { }) ];
  boot.blacklistedKernelModules = [
    "rtw88_8821ce"
    "rtw88_8821c"
    "rtw88_pci"
    "rtw88_core"
  ];

  virtualisation.virtualbox.host.enable = true;
  users.users.fatjon.extraGroups = [ "vboxusers" ];
  users.users.fatjon.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAwetI0mnb/fs/tX4a0N0v3RI4julS75nm+TGPyImyEX fatjon@laptop"
  ];

  system.stateVersion = "26.05";
}
