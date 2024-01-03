{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.dots.profiles.sway;

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
  };

  startw = pkgs.writeScriptBin "startw"
    ''
      export LIBVA_DRIVER_NAME=nvidia
      export XDG_SESSION_TYPE=wayland
      export GBM_BACKEND=nvidia-drm
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export WLR_NO_HARDWARE_CURSORS=1

      exec sway
    '';

  sptfy = pkgs.writeScriptBin "sptfy"
    ''
      spotify --enable-features=UseOzonePlatform --ozone-platform=wayland
    '';
in
{
  options.dots.profiles.sway = {
    enable = mkEnableOption "sway profile";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      pkgs.rofi-wayland
      # pkgs.swaylock-effects
      configure-gtk
      dbus-sway-environment
      sptfy
      startw
    ];

    services.wlsunset = {
      enable = true;
      latitude = "47.4";
      longitude = "8.5";
      temperature = {
        day = 5700;
        night = 3200;
      };
    };

    systemd.user.services.wlsunset.Install = { WantedBy = [ "graphical.target" ]; };

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
            margin-left: 0px;
            margin-right: 0px;
            margin-top: 0px;
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
          # "mpd"
        ];
        modules-center = [
        ];
        modules-right = [
          "memory"
          "cpu"
          "temperature"
          # "network"
          "tray"
          "clock"
        ];

        "wlr/workspaces" = {
          "format" = "{icon}";
          # "on-click" = "activate";
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
          "on-click-middle" = "alacritty --class='ncmpcpp' ncmpcpp ";
          "on-scroll-up" = "mpc --quiet prev";
          "on-scroll-down" = "mpc --quiet next";
          "smooth-scrolling-threshold" = 5;
          "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
        };

        "network" = {
          "format-disconnected" = "󰯡 Disconnected";
          "format-ethernet" = "󰀂 {ifname} ({ipaddr})";
          # "format-linked" = "󰖪 {essid} (No IP)";
          # "format-wifi" = "󰖩 {essid}";
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

    home.file.".config/sway/config".source = ./sway/config;
  };
}
