{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Hyprland
  programs.hyprland.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    # powerOnBoot = true;

    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };

    # Policy.AutoEnable = true;
   };
  };
  
  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.rajveer = import ./home.nix;
  };

  # Security
  security = {
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
    };
    polkit.enable = true;
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking
  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";


  # services
  services = {
    gvfs.enable = true;
    udisks2.enable = true;

    # GDM
    displayManager = {
      gdm.enable = true;
      defaultSession = "hyprland";
      autoLogin.user = "rajveer";
      autoLogin.enable = true;
    };

    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];

      #xkb
      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  # asus
  services.asusd.enable = true;
  services.supergfxd.enable = true;

  #keyd
  services.keyd = {
   enable = true;
   keyboards = {
     "default" = {
       ids = [ "*" ];
       settings = {
         main = {
           capslock = "esc";
           esc = "capslock";
           leftcontrol = "leftalt";
           leftalt = "leftcontrol";
           rightcontrol = "rightalt";
           rightalt = "rightcontrol";
         };
       };
     };
   };
 };

  # zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
	enable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rajveer = {
    isNormalUser = true;
    description = "Rajveer Singh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # system packages
  environment.systemPackages = with pkgs; [
  hyprland
  asusctl
  ];

  fonts.packages = with pkgs; [
    nerd-fonts._3270
  ];
 
  system.stateVersion = "25.05";
}
