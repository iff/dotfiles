{ pkgs, inputs, ... }:

let

in
{
  home = {
    packages = with pkgs; [
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      hyprpaper
      rofi-wayland
      # swaylock-effects
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  programs.swaylock = {
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      ring-color = "3b4252";
      key-hl-color = "880033";
      line-color = "00000000";
      inside-color = "00000088";
      separator-color = "00000000";
      # grace = 2;
    };
  };

  programs.waybar = {
    enable = true;
    # systemd = {
    #   enable = false;
    #   target = "graphical-session.target";
    # };
    style = ''
        * {
          font-family: "Ubuntu Mono Nerd Font";
          font-size: 10pt;
          font-weight: bold;
          border-radius: 0px;
          transition-property: background-color;
          transition-duration: 0.5s;
        }
        @keyframes blink_red {
          to {
            background-color: rgb(242, 143, 173);
            color: rgb(26, 24, 38);
          }
        }
        .warning, .critical, .urgent {
          animation-name: blink_red;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        window#waybar {
          background-color: transparent;
        }
        window > box {
          margin-left: 5px;
          margin-right: 5px;
          margin-top: 5px;
          background-color: #3b4252;
        }
      #workspaces {
              padding-left: 0px;
              padding-right: 4px;
            }
      #workspaces button {
              padding-top: 5px;
              padding-bottom: 5px;
              padding-left: 6px;
              padding-right: 6px;
              color:#D8DEE9;
            }
      #workspaces button.active {
              background-color: rgb(181, 232, 224);
              color: rgb(26, 24, 38);
            }
      #workspaces button.urgent {
              color: rgb(26, 24, 38);
            }
      #workspaces button:hover {
              background-color: #B38DAC;
              color: rgb(26, 24, 38);
            }
            tooltip {
              /* background: rgb(250, 244, 252); */
              background: #3b4253;
            }
            tooltip label {
              color: #E4E8EF;
            }
      #mode, #clock, #memory, #temperature, #cpu, #mpd, #temperature, #backlight, #pulseaudio, #network {
              padding-left: 10px;
              padding-right: 10px;
            }
      #memory {
              color: #8EBBBA;
            }
      #cpu {
              color: #B38DAC;
            }
      #clock {
              color: #E4E8EF;
            }
      #temperature {
              color: #80A0C0;
            }
      #backlight {
              color: #A2BD8B;
            }
      #pulseaudio {
              color: #E9C98A;
            }
      #network {
              color: #99CC99;
            }

      #network.disconnected {
              color: #CCCCCC;
            }
      #tray {
              padding-right: 8px;
              padding-left: 10px;
            }
      #tray menu {
              background: #3b4252;
              color: #DEE2EA;
      }
      #mpd.paused {
              color: rgb(192, 202, 245);
              font-style: italic;
            }
      #mpd.stopped {
              background: transparent;
            }
      #mpd {
                color: #E4E8EF;
            }
    '';
    settings = [{
      "layer" = "top";
      "position" = "top";

      modules-left = [
        "wlr/workspaces"
        "mpd"
      ];
      modules-center = [
      ];
      modules-right = [
        "pulseaudio"
        "memory"
        "cpu"
        "temperature"
        "network"
        "clock"
        "tray"
      ];

      "wlr/workspaces" = {
        "format" = "{icon}";
        "on-click" = "activate";
      };

      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon} {volume}%";
        "format-muted" = "󰖁 Muted";
        "format-icons" = {
          "default" = [ "" "" "" ];
        };
        "states" = {
          "warning" = 85;
        };
        "on-click" = "pamixer -t";
        "tooltip" = false;
      };

      "clock" = {
        "interval" = 1;
        "format" = "{:%I:%M %p}";
        "tooltip" = true;
      };

      "memory" = {
        "interval" = 1;
        "format" = "󰍛 {percentage}%";
        "states" = {
          "warning" = 85;
        };
      };

      "cpu" = {
        "interval" = 1;
        "format" = "󰻠 {usage}%";
      };

      "mpd" = {
        "max-length" = 25;
        "format" = "<span foreground='#bb9af7'></span> {title}";
        "format-paused" = " {title}";
        "format-stopped" = "<span foreground='#bb9af7'></span>";
        "format-disconnected" = "";
        "on-click" = "mpc --quiet toggle";
        "on-click-right" = "mpc update; mpc ls | mpc add";
        "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
        "on-scroll-up" = "mpc --quiet prev";
        "on-scroll-down" = "mpc --quiet next";
        "smooth-scrolling-threshold" = 5;
        "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
      };

      "network" = {
        "format-disconnected" = "󰯡 Disconnected";
        "format-ethernet" = "󰀂 {ifname} ({ipaddr})";
        "format-linked" = "󰖪 {essid} (No IP)";
        "format-wifi" = "󰖩 {essid}";
        "interval" = 1;
        "tooltip" = false;
      };

      "temperature" = {
        "tooltip" = false;
        "format" = " {temperatureC}°C";
      };

      "tray" = {
        "icon-size" = 13;
        "spacing" = 5;
      };
    }];
  };
}
