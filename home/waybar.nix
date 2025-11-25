{ pkgs, host, lib, ... }:
let
  inherit (import ../hosts/${host}/variables.nix) terminal;
  inherit (import ../hosts/${host}/colors.nix { inherit pkgs; }) colors;
in with lib; {
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";

      modules-center = [
        "pulseaudio"
        "hyprland/workspaces"
        "cpu"
        "tray"
      ]; # Eterna: [ "hyprland/window" ]
      modules-left = [
        "custom/startmenu"
        "hyprland/window"
      ]; # Eternal:  [ "hyprland/workspaces" "cpu" "memory" "network" ]
      modules-right = [
        "custom/notification"
        "battery"
        "clock"
      ]; # Eternal: [ "idle_inhibitor" "pulseaudio" "clock"  "custom/notification" "tray" ]

      "hyprland/workspaces" = {
        format = "{name} {windows} ";
        format-window-separator = " ";
        format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
        };
        window-rewrite-default = "";
        window-rewrite = {
          "title<.*YouTube Music.*>" = "";
          "title<.*YouTube.*>" = "";
          "class<thunar>" = "";
          "class<.*chrome.*>" = "󰊯";
          "class<(Alacritty|.*ghostty.*)>" = "";
          "title<.*nvim.*>" = "";
          "title<Typst Preview>" = "";
          "class<sioyek>" = "";
          "class<.*Gimp.*>" = "";
          "class<.*inkscape.*>" = "";
          "title<.*glava.*>" = "󱑽";
          "title<.*btop.*>" = "";
        };
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      bluetooth = {
        "on-click" =
          "rofi-bluetooth -i -show drun -config ~/.config/rofi/config-long.rasi";
        "on-click-right" = "blueman-manager";
        format = "{icon}";
        interval = 15;
        "format-icons" = {
          on = "<span foreground='#43242B'></span>";
          off = "<span foreground='#76946A'>󰂲</span>";
          disabled = "󰂲";
          connected = "";
        };
        "tooltip-format" = "{device_alias} {status}";
      };
      "clock" = {
        format = "  {:%H:%M}";
        tooltip = true;
        tooltip-format =
          "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
      };
      "hyprland/window" = {
        max-length = 40;
        separate-outputs = false;
      };
      "memory" = {
        interval = 5;
        format = " {}%";
        tooltip = true;
        on-click = "${terminal} -e btop";
      };
      "cpu" = {
        interval = 5;
        format = " {usage:2}%";
        tooltip = true;
        on-click = "${terminal} -e btop";
      };
      "network" = {
        format-icons = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
        format-ethernet = " {bandwidthDownBits}";
        format-wifi = " {bandwidthDownBits}";
        format-disconnected = "󰤮";
        tooltip = false;
        on-click = "${terminal} -e btop";
      };
      "tray" = { spacing = 12; };
      "pulseaudio" = {
        format = "{icon} {volume}% {format_source}";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = " {volume}%";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [ "" " " " " ];
        };
        on-click = "pavucontrol";
      };
      "custom/startmenu" = {
        tooltip = false;
        format = "";
        on-click = "rofi -show drun";
      };
      "custom/notification" = {
        tooltip = false;
        format = "{icon} {}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification =
            "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t";
        escape = true;
      };
      "battery" = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-plugged = " {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        on-click = "";
        tooltip = false;
      };
    }];
    style = concatStrings [''
      * {
        font-size: 16px;
        font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
        font-weight: bold;
      }
      window#waybar {
        /*

          background-color: rgba(26,27,38,0);
          border-bottom: 1px solid rgba(26,27,38,0);
          border-radius: 0px;
          color: #${colors.base0F};
        */

        background-color: rgba(26,27,38,0);
        border-bottom: 1px solid rgba(26,27,38,0);
        border-radius: 0px;
        color: #${colors.base0F};
      }
      #workspaces {
        /*
          Eternal
          background: linear-gradient(180deg, #${colors.base00}, #${colors.base01});
          margin: 5px 5px 5px 0px;
          padding: 0px 10px;
          border-radius: 0px 15px 50px 0px;
          border: 0px;
          font-style: normal;
          color: #${colors.base00};
        */
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        margin: 5px;
        padding: 0px 1px;
        border-radius:  15px 15px;
        border: 0px;
        font-style: normal;
        color: #${colors.base00};
      }
      #workspaces button {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: #${colors.base00};
        background: linear-gradient(45deg, #${colors.base0D}, #${colors.base0E}),
                    linear-gradient(180deg, rgba(0,0,0,0.2), rgba(0,0,0,0.6));
        opacity: 0.5;
        transition: all 0.3s ease-in-out;
      }
      #workspaces button.active {
        padding: 0px 5px;
        margin: 4px 3px;
        border-radius: 15px;
        border: 0px;
        color: #${colors.base00};
        background: linear-gradient(45deg, #${colors.base0D}, #${colors.base0E}),
                    linear-gradient(180deg, rgba(0,0,0,0.2), rgba(0,0,0,0.7));
        opacity: 1.0;
        min-width: 40px;
        transition: all 0.3s ease-in-out;
      }
      #workspaces button:hover {
        border-radius: 15px;
        color: #${colors.base00};
        background: linear-gradient(45deg, #${colors.base0D}, #${colors.base0E});
        opacity: 0.8;
      }
      tooltip {
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border: 1px solid #${colors.base0E};
        border-radius: 10px;
      }
      tooltip label {
        color: #${colors.base07};
      }
      #window {
        /*
          Eternal
          color: #${colors.base0C};
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 15px;
          margin: 5px;
          padding: 2px 20px;
        */
        margin: 5px;
        padding: 2px 20px;
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 50px 15px 50px 15px;
      }
      #memory {
        color: #${colors.base0F};
        /*
          Eternal
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 50px 15px 50px 15px;
          margin: 5px;
          padding: 2px 20px;
        */
        background: #${colors.base01};
        margin: 5px;
        padding: 2px 20px;
        border-radius: 15px 50px 15px 50px;
      }
      #clock {
        color: #${colors.base0C};
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 15px 50px 15px 50px;
          margin: 5px;
          padding: 2px 20px;
      }
      #idle_inhibitor {
        color: #${colors.base0A};
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 50px 15px 50px 15px;
          margin: 5px;
          padding: 2px 20px;
      }
      #cpu {
        color: #${colors.base0C};
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 50px 15px 50px 15px;
          margin: 5px;
          padding: 2px 20px;
      }
      #disk {
        color: #${colors.base0F};
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 15px 50px 15px 50px;
          margin: 5px;
          padding: 2px 20px;
      }
      #battery {
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #network {
        color: #${colors.base09};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #tray {
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 50px 15px 50px 15px;
        margin: 5px;
        padding: 2px 20px;
      }
      #bluetooth {
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #pulseaudio {
        color: #${colors.base0C};
        /*
          Eternal
          background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
          border-radius: 15px 50px 15px 50px;
          margin: 5px;
          padding: 2px 20px;
        */
        background: linear-gradient(180deg, rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        margin: 4px;
        padding: 2px 20px;
        border-radius: 15px 50px 15px 50px;
      }
      #custom-notification {
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #custom-startmenu {
        color: #${colors.base0C};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        font-size: 15pt;
        border-radius: 0px 15px 50px 0px;
        margin: 5px 5px 5px 0px;
        padding: 2px 20px;
      }
      #idle_inhibitor {
        color: #${colors.base09};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 15px 50px 15px 50px;
        margin: 5px;
        padding: 2px 20px;
      }
      #custom-exit {
        color: #${colors.base0E};
        background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.8));
        border-radius: 15px 0px 0px 50px;
        margin: 5px 0px 5px 5px;
        padding: 2px 20px;
      }
    ''];
  };
}
