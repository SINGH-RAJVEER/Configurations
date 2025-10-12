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
    neovim
    ghostty
    git
    brave
    swww
    eww
    hyprlock
    hypridle
    thunderbird
    deja-dup
    bun
    gemini-cli
    pavucontrol
    vscode
    blueman
    exfatprogs
    steam
    libreoffice
    nautilus
    brightnessctl
    eza
    zoxide
    fzf
    bat
    rustup
    zsh
    xh
    delta
    networkmanagerapplet
  ];

  home.stateVersion = "25.05";
}

