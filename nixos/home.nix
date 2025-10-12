{
  config,
  pkgs,
  ...
}:{
  home.username = "rajveer";
  home.homeDirectory = "/home/rajveer";

  home.packages = with pkgs; [
    neovim
    ghostty
    git
    wofi
    brave
    swww
    eww
    waybar
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
    starship
    brightnessctl
    eza
    zoxide
    fzf
    bat
    rustup
    zsh
    xh
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
