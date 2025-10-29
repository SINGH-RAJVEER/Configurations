{ config, pkgs, lib, inputs, ... }:

{
  disabledModules = ["security/pam.nix"];

  imports =
    [
      ./hardware-configuration.nix
      "${inputs.nixpkgs-howdy}/nixos/modules/security/pam.nix"
      "${inputs.nixpkgs-howdy}/nixos/modules/services/security/howdy"
      "${inputs.nixpkgs-howdy}/nixos/modules/services/misc/linux-enable-ir-emitter.nix"
    ];

  # flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs = {
    # Hyprland
    hyprland.enable = true;

    # appimage
    appimage = {
      enable = true;
      binfmt = true;
      package = pkgs.appimage-run.override { extraPkgs = pkgs: 
	[

        ]; 
      };
    };
  };

  # Bootloader.
  boot = {
    # plymouth
    plymouth = {
      enable = true;
      theme = "rings";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "rings" ];
        })
      ];
    };

    # silent-boot
    consoleLogLevel = 3;
    initrd.verbose = false;
    initrd.availableKernelModules = [ "amdgpu" ];
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "amdgpu.sg_display=0"
    ];
    loader.timeout = 0;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # hardware
  hardware = {
    # nvidia
    graphics.enable = true;
    graphics.enable32Bit = true;

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        amdgpuBusId = "PCI:65:0:0";
        nvidiaBusId = "PCI:64:0:0";
      };

      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };

    # Bluetooth
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
      };
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
    # sudo-rs
    sudo-rs = {
      enable = true;
      wheelNeedsPassword = true;
    };

    # polkit
    polkit.enable = true;
  };

  # latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # systemd
  systemd.services.create_ap.wantedBy = lib.mkForce [ ];

  # services
  services = {

    # howdy
    howdy = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.howdy;
      settings = {
        video.device_path = "/dev/video2";
        core.no_confirmation = true;
	video.capture_successful = false;
        video.dark_threshold = 90;
      };
    };

    linux-enable-ir-emitter = {
      enable = true;
      package = inputs.nixpkgs-howdy.legacyPackages.${pkgs.system}.linux-enable-ir-emitter;
    };

    gvfs.enable = true;
    udisks2.enable = true;

    # flatpak
    flatpak.enable = true;

    # cups
    printing.enable = true;

    # mongodb
    mongodb.enable = true;

    # GDM
    displayManager = {
      gdm.enable = true;
      defaultSession = "hyprland";
      autoLogin.user = "rajveer";
      autoLogin.enable = false;
    };

    xserver = {
      enable = true;
      excludePackages = with pkgs; [ xterm ];

      videoDrivers = [ "amdgpu" "nvidia" ];

      xkb = {
        layout = "us";
        variant = "";
      };
    };
  };

  # asus
  services.asusd.enable = true;
  # services.supergfxd.enable = true;

  # keyd
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

  # Hyprland environment variables for NVIDIA
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GL_GSYNC_ALLOWED = "1";
    __GL_VRR_ALLOWED = "1";
  };

  # zsh
  users.defaultUserShell = pkgs.zsh;
  programs = {
  nix-ld.enable = true;
  steam.enable = true;
  zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
    };
  };
  };

  # Define a user account
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
    nvtopPackages.nvidia
  ];

  fonts.packages = with pkgs; [
    nerd-fonts._3270
  ];
 
  system.stateVersion = "25.05";
}

