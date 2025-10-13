{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        spacing = "1";
        margin = "0";
        
        modules-left = [
          "hyprland/workspaces"
          "hyprland/mode"
        ];
        
        modules-center = [
          "clock"
        ];
        
        modules-right = [
          "tray"
          "network"
          "custom/hotspot"
          "bluetooth"
          "pulseaudio"
	  "custom/playerctl"
          "backlight"
          "cpu"
          "memory"
          "battery"
          "custom/uptime"
        ];

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        "hyprland/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "custom/playerctl" = {
          format = " 󰐊  {}";
          return-type = "json";
          max-length = 40;
          exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} - {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{artist}} - {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
          on-click = "playerctl play-pause";
          on-click-right = "playerctl next";
        };

        "custom/uptime" = {
          format = "󰔟  {}";
          exec = "uptime -p | sed 's/up //; s/ days/d/; s/ hours/h/; s/ minutes/m/'";
          interval = 60;
        };

        clock = {
          format = "{:%A, %B %d, %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            format = {
              months = "<b>{}</b>";
              days = "{}";
              weeks = "<b>W{}</b>";
              weekdays = "<b>{}</b>";
              today = "<b><u>{}</u></b>";
            };
          };
        };

        cpu = {
          format = "󰘚  {usage}%";
          tooltip = true;
          interval = 5;
        };

        memory = {
          format = "󰍛  {}%";
          interval = 3;
        };

        "custom/hotspot" = {
          format = "󰀂 ";
          on-click = "";
          on-click-middle = "systemctl is-active --quiet create_ap && sudo systemctl stop create_ap || sudo systemctl start create_ap";
        };

        battery = {
          states = {
            full = 100;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "󰂄  {capacity}%";
          format-plugged = "󰂄  {capacity}%";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };

        network = {
          format-wifi = "{icon}  {essid}";
          format-ethernet = "󰈀  {ifname}";
          format-linked = "󰈀  {ifname} (No IP)";
          format-disconnected = "󰖪 Disconnected";
          format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" ];
          tooltip-format = "{ifname}: {ipaddr}";
          on-click = "nm-applet &";
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰥰";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰄝";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          on-click-right = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-scroll-up = "pactl set-sink-volume @DEFAULT_SINK@ +2%";
          on-scroll-down = "pactl set-sink-volume @DEFAULT_SINK@ -2%";
        };

        backlight = {
          format = "{icon}  {percent}%";
          format-icons = [ "󰃞" "󰃟" "󰃠" ];
          on-scroll-up = "brightnessctl set +1%";
          on-scroll-down = "brightnessctl set 1%-";
        };

        tray = {
          icon-size = "18";
          spacing = "5";
        };

        bluetooth = {
          #format = "{icon}  {status} {device_alias}";
          format-disabled = "󰂲  off";
          format-connected = "󰂯  {device_alias}";
          format-connected-battery = "󰂯  {device_alias} {device_battery_percentage}%";
          #format-icons = [ "󰂯" "󰂲" ];

          # tooltop
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";

          on-click = "blueman-manager";
        };
      };
    };

    style = ''
      /* Grey and White Colorscheme */
      @define-color background #2E2E2E;
      @define-color background-light #424242;
      @define-color foreground #FFFFFF;
      @define-color grey #BDBDBD;

      /* Module-specific colors */
      @define-color workspaces-color @foreground;
      @define-color workspaces-focused-bg @grey;
      @define-color workspaces-focused-fg @background;
      @define-color workspaces-urgent-bg @grey;
      @define-color workspaces-urgent-fg @background;

      * {
        border: none;
        border-radius: 0;
        font-family: "Iosevka Nerd Font";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background-color: transparent;
        color: @foreground;
      }

      /* Common module styling */
      #mode, #clock, #tray, #network, #bluetooth, #pulseaudio, #backlight, #cpu, #custom-hotspot, #custom-playerctl, #memory, #battery, #custom-uptime, #custom-playerctl {
        padding: 0 10px;
        margin: 3px;
        background-color: @background-light;
        border-radius: 3px;
      }

      /* Workspaces styling */
      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        background-color: @background-light;
        color: #FFFFFF;
        border-radius: 3px;
        font-weight: 900;
        border: none;
        padding: 2px 6px;
        margin: 3px;
      }

      #workspaces button:hover {
        background: @background-light;
        box-shadow: inherit;
      }

      #workspaces button.active {
        background-color: #FFFFFF;
        color: #000000;
        border-radius: 3px;
        font-weight: 900;
        border: none;
        padding: 2px 6px;
        margin: 3px;
      }

      #workspaces button.urgent {
        background-color: @workspaces-urgent-bg;
        color: @workspaces-urgent-fg;
      }

      /* Module-specific styling */
      #mode, #clock, #cpu,
      #memory, #battery, #network, #pulseaudio,
      #backlight, #custom-uptime, #bluetooth {
        color: @foreground;
      }

      #network.disconnected {
        color: @grey;
      }

      #pulseaudio.muted {
        color: @grey;
      }

      #tray {
        background-color: transparent;
        padding: 0 10px;
        margin: 0 2px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        color: @grey;
        border-bottom-color: @grey;
      }

      #battery.full {
        background-color: white;
        color: black;
      }
    '';
  };
}

