{ config, pkgs, ... } :

{
  imports = [
    ./configs/wofi.nix
    ./configs/starship.nix
    ./configs/waybar.nix
  ];

  home.username = "rajveer";
  home.homeDirectory = "/home/rajveer";

  home.packages = with pkgs; [
    # TUIs
    eza
    zoxide
    fzf
    bat
    ripgrep
    xh
    delta
    neovim
    gemini-cli

    # System
    git
    zsh
    networkmanagerapplet
    swww
    eww
    hyprlock
    hypridle
    pavucontrol
    blueman
    exfatprogs
    brightnessctl
 
    # development
    rustup
    bun
    python314
    go
    jdk
    uv

    # GUIs
    ghostty
    brave
    anytype
    thunderbird
    deja-dup
    vscode
    steam
    libreoffice
    nautilus
    kdePackages.dolphin
  ];

  home.stateVersion = "25.05";
}

