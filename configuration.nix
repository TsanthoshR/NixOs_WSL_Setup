{ config, pkgs, ... }:
{
  # ===== BOOT & FILESYSTEM CONFIGURATION =====
  # Minimal boot configuration for WSL
  boot.loader.grub.enable = false;
  boot.loader.grub.devices = [ ];

  # Remove vhba - it doesn't exist in this kernel
  # boot.initrd.availableKernelModules = [ "vhba" "hv_storvsc" "hv_netvsc" ];
  boot.initrd.availableKernelModules = [ "hv_storvsc" "hv_netvsc" ];

  # Root filesystem for WSL
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "size=50%" "mode=755" ];
    };

    # Only expose this one host folder. No other Windows path (C:\, rest of D:\,
    # etc.) is reachable from inside this sandbox.
    "/mnt/d" = {
      device = "D:\\Software_Installations\\nix";
      fsType = "drvfs";
      options = [ "rw" "noatime" "metadata" "uid=1000" "gid=100" ];
      noCheck = true;
    };
  };

  # Disable WSL's default automount of every fixed drive (C:\, D:\, ...).
  # Without this, WSL mounts all of them read-write regardless of the
  # fileSystems entry above.
  environment.etc."wsl.conf".text = ''
    [automount]
    enabled = false
  '';

  # ===== SYSTEM PACKAGES =====
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    zsh
    hack-font
    tmux
    htop
    tree
  ];

  # ===== FONTS =====
  fonts.packages = with pkgs; [
    hack-font
  ];

  # ===== USER CONFIGURATION =====
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # ===== ZSH SYSTEM CONFIGURATION =====
  programs.zsh.enable = true;
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      glibc
    ];
  };

  # ===== NIX SETTINGS =====
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
    trusted-users = root nixos
  '';

  # ===== NETWORK =====
  networking.hostName = "nixos-wsl";
  networking.useDHCP = true;
  networking.firewall.enable = false;
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  system.stateVersion = "26.05";
}
