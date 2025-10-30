{ config, pkgs, inputs, ... } :

{
  imports = [
    ./configs/wofi.nix
    ./configs/starship.nix
    ./configs/waybar.nix
    ./configs/hypr/hypridle.nix
    ./configs/hypr/hyprlock.nix
  ];

  home = {
    username = "rajveer";
    homeDirectory = "/home/rajveer";
  };

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
    yazi
    mpv
    grimblast
    cmake

    # development
    rustup
    bun
    python314
    go
    jdk
    uv
    insomnia
    mongodb-compass
    mongosh
    github-desktop
    vscode
    code-cursor
    zed-editor

    # GUIs
    ghostty
    brave
    anytype
    thunderbird
    deja-dup
    steam
    libreoffice
    nautilus
    papers
    mission-center
  ];

  home.stateVersion = "25.05";
}
