{ config, pkgs, ... } :

{
  imports = [
    ./configs/wofi.nix
    ./configs/starship.nix
    ./configs/waybar.nix
    ./configs/hypr/hypridle.nix
    ./configs/hypr/hyprlock.nix
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
    opencode
    gemini-cli
    stylua

    # System
    git
    gcc
    zsh
    networkmanagerapplet
    swww
    eww
    pavucontrol
    blueman
    exfatprogs
    brightnessctl
    linux-wifi-hotspot
    yazi
    mpv
    grimblast
 
    # development
    rustup
    bun
    python314
    go
    jdk
    uv
    insomnia
    mongodb
    mongodb-compass
    mongosh

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
    zed-editor
    papers
    github-desktop
  ];

  home.stateVersion = "25.05";
}

