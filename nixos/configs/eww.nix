{ config, pkgs, lib, ... }:

{
  # Enable eww
  programs.eww = {
    enable = true;
    package = pkgs.eww;
  };

  # Write eww configuration files
  xdg.configFile = {
    # Main eww configuration
    "eww/eww.yuck".text = ''
      ;; Variables for polling system info
      (defpoll time :interval "1s" "date '+%A, %B %d, %H:%M'")
      (defpoll uptime :interval "60s" "uptime -p | sed 's/up //; s/ days/d/; s/ hours/h/; s/ minutes/m/'")
      (defpoll cpu :interval "1s" "top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\\([0-9.]*\\)%* id.*/\\1/' | awk '{print 100 - $1}'")
      (defpoll memory :interval "1s" "free | grep Mem | awk '{print int($3/$2 * 100)}'")
      (defpoll temperature :interval "1s" "sensors | grep 'Package id 0:' | awk '{print int($4)}' || echo '0'")
      (defpoll battery :interval "1s" "cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo '0'")
      (defpoll battery_status :interval "1s" "cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo 'Unknown'")
      (defpoll brightness :interval "1s" "brightnessctl g | awk '{printf \"%d\", ($1/$(brightnessctl m))*100}'")
      (defpoll volume :interval "1s" "pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\\d+%' | head -1 | tr -d '%'")
      (defpoll muted :interval "1s" "pactl get-sink-mute @DEFAULT_SINK@ | grep -q yes && echo 'true' || echo 'false'")
      (defpoll network_status :interval "2s" "nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 || echo 'Disconnected'")
      (defpoll network_type :interval "2s" "nmcli -t -f TYPE,STATE device | grep ':connected' | cut -d: -f1")
      (defpoll bluetooth_status :interval "2s" "bluetoothctl show | grep 'Powered: yes' >/dev/null && echo 'on' || echo 'off'")
      (defpoll bluetooth_device :interval "2s" "bluetoothctl info | grep 'Name:' | cut -d' ' -f2- || echo '''")
      (deflisten workspaces :initial "[]" "${config.xdg.configHome}/eww/scripts/workspaces.sh")
      (deflisten current_workspace :initial "1" "${config.xdg.configHome}/eww/scripts/current_workspace.sh")

      ;; Main bar window
      (defwindow bar
        :monitor 0
        :windowtype "dock"
        :geometry (geometry :x "0%"
                            :y "0%"
                            :width "100%"
                            :height "30px"
                            :anchor "bottom center")
        :reserve (struts :side "bottom" :distance "30px")
        (bar))

      ;; Bar layout
      (defwidget bar []
        (centerbox :class "bar"
          (box :class "left" :halign "start" :spacing 1
            (workspaces-widget)
          )
          (box :class "center" :halign "center"
            (clock)
          )
          (box :class "right" :halign "end" :spacing 1
            (network)
            (bluetooth)
            (audio)
            (backlight)
            (cpu-widget)
            (temperature-widget)
            (memory-widget)
            (battery-widget)
            (uptime-widget)
            (tray-module)  ;; Changed from (systray)
          )
        )
      )

      ;; Workspaces widget
      (defwidget workspaces-widget []
        (box :class "workspaces"
          (for ws in workspaces
            (button :class "''${ws == current_workspace ? 'active' : ""}"
                    :onclick "hyprctl dispatch workspace ''${ws}"
              "''${ws}"
            )
          )
        )
      )

      ;; Clock
      (defwidget clock []
        (box :class "module clock"
          (label :text time)
        )
      )

      ;; Network
      (defwidget network []
        (button :class "module network ''${network_status == 'Disconnected' ? 'disconnected' : ""}"
                :onclick "${config.home.homeDirectory}/.local/bin/toggle-nm-applet.sh"
          (label :text "''${network_type == 'wifi' ? '󰤨' : network_type == 'ethernet' ? '󰈀' : '󰖪'}  ''${network_status}")
        )
      )

      ;; Bluetooth
      (defwidget bluetooth []
        (button :class "module bluetooth"
                :onclick "blueman-manager &"
          (label :text "''${bluetooth_status == 'on' ? "" : ""}  ''${bluetooth_device != "" ? bluetooth_device : bluetooth_status}")
        )
      )

      ;; Audio/PulseAudio
      (defwidget audio []
        (button :class "module pulseaudio ''${muted == 'true' ? 'muted' : ""}"
                :onclick "pavucontrol &"
                :onrightclick "pactl set-sink-mute @DEFAULT_SINK@ toggle"
          (label :text "''${muted == 'true' ? '󰝟' : volume <= 33 ? '󰕿' : volume <= 66 ? '󰖀' : '󰕾'}  ''${volume}%")
        )
      )

      ;; Backlight
      (defwidget backlight []
        (button :class "module backlight"
          (label :text "''${brightness <= 33 ? '󰃞' : brightness <= 66 ? '󰃟' : '󰃠'}  ''${brightness}%")
        )
      )

      ;; CPU
      (defwidget cpu-widget []
        (button :class "module cpu"
                :onclick "kitty -e htop &"
          (label :text "󰘚  ''${round(cpu, 0)}%")
        )
      )

      ;; Temperature
      (defwidget temperature-widget []
        (button :class "module temperature"
                :onclick "kitty -e s-tui &"
          (label :text "''${temperature < 50 ? '󱃃' : temperature < 80 ? '󰔏' : '󱃂'}  ''${temperature}°C")
        )
      )

      ;; Memory
      (defwidget memory-widget []
        (button :class "module memory"
                :onclick "kitty -e htop &"
          (label :text "󰍛  ''${memory}%")
        )
      )

      ;; Battery
      (defwidget battery-widget []
        (box :class "module battery ''${battery <= 15 ? 'critical' : battery <= 30 ? 'warning' : battery == 100 ? 'full' : ""}"
          (label :text "''${battery_status == 'Charging' || battery_status == 'Full' ? '󰂄' : 
                         battery <= 10 ? '󰂎' : battery <= 20 ? '󰁺' : battery <= 30 ? '󰁻' : 
                         battery <= 40 ? '󰁼' : battery <= 50 ? '󰁽' : battery <= 60 ? '󰁾' : 
                         battery <= 70 ? '󰁿' : battery <= 80 ? '󰂀' : battery <= 90 ? '󰂁' : '󰁹'}  ''${battery}%")
        )
      )

      ;; Uptime
      (defwidget uptime-widget []
        (box :class "module uptime"
          (label :text "󰔟  ''${uptime}")
        )
      )

      ;; System tray - rename the widget
      (defwidget tray-module []
        (box :class "module tray"
          (systray :pack-direction "ltr" :icon-size 18 :spacing 5)
        )
      )
    '';

    # Eww styling
    "eww/eww.scss".text = ''
      /* Grey and White Colorscheme */
      $background: #2E2E2E;
      $background-light: #424242;
      $foreground: #FFFFFF;
      $grey: #BDBDBD;

      * {
        all: unset;
        font-family: "Iosevka Nerd Font";
        font-size: 14px;
      }

      .bar {
        background-color: $background;
        color: $foreground;
        padding: 0;
      }

      .left, .center, .right {
        padding: 0 5px;
      }

      .module {
        padding: 0 10px;
        margin: 3px;
        background-color: $background-light;
        border-radius: 3px;
        color: $foreground;
      }

      /* Workspaces */
      .workspaces {
        button {
          padding: 0 10px;
          background-color: transparent;
          color: $foreground;
          margin: 0;
          
          &:hover {
            background: $background-light;
          }
          
          &.active {
            background-color: #FFFFFF;
            color: #000000;
            border-radius: 3px;
            font-weight: 900;
            padding: 0 10px;
            margin: 3px;
          }
          
          &.urgent {
            background-color: $grey;
            color: $background;
          }
        }
      }

      /* Network disconnected state */
      .network.disconnected {
        color: $grey;
      }

      /* Audio muted state */
      .pulseaudio.muted {
        color: $grey;
      }

      /* Battery states */
      .battery.full {
        background-color: white;
        color: black;
      }

      /* Tray */
      .tray {
        background-color: transparent;
        padding: 0 10px;
        margin: 0 2px;
      }
    '';

    # Workspace tracking script
    "eww/scripts/workspaces.sh" = {
      text = ''
        #!/usr/bin/env bash
        hyprctl workspaces -j | ${pkgs.jq}/bin/jq -r '.[].id' | sort -n | ${pkgs.jq}/bin/jq -R . | ${pkgs.jq}/bin/jq -s .
        ${pkgs.socat}/bin/socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
          hyprctl workspaces -j | ${pkgs.jq}/bin/jq -r '.[].id' | sort -n | ${pkgs.jq}/bin/jq -R . | ${pkgs.jq}/bin/jq -s .
        done
      '';
      executable = true;
    };

    # Current workspace tracking script
    "eww/scripts/current_workspace.sh" = {
      text = ''
        #!/usr/bin/env bash
        hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.id'
        ${pkgs.socat}/bin/socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
          hyprctl activeworkspace -j | ${pkgs.jq}/bin/jq -r '.id'
        done
      '';
      executable = true;
    };
  };

  # Required packages for the eww bar to function
  home.packages = with pkgs; [
    brightnessctl
    networkmanager
    bluez
    pulseaudio
    lm_sensors
    htop
    s-tui
    pavucontrol
    blueman
    socat
    jq
  ];
}

