{ config, inputs, lib, pkgs, ... }:

# see https://github.com/0xc000022070/zen-browser-flake
with lib;

let
  cfg = config.dots.zen;
  src = inputs.zen;

  zen-unscaled = pkgs.writeScriptBin "zen-unscaled"
    ''
      GDK_SCALE= GDK_DPI_SCALE= zen
    '';

  runtimeLibs = with pkgs; [
    libGL
    libGLU
    libevent
    libffi
    libjpeg
    libpng
    libstartup_notification
    libvpx
    libwebp
    stdenv.cc.cc
    fontconfig
    libxkbcommon
    zlib
    freetype
    gtk3
    libxml2
    dbus
    xcb-util-cursor
    alsa-lib
    libpulseaudio
    pango
    atk
    cairo
    gdk-pixbuf
    glib
    udev
    libva
    mesa
    libnotify
    cups
    pciutils
    ffmpeg
    libglvnd
    pipewire
  ] ++ (with pkgs.xorg; [
    libxcb
    libX11
    libXcursor
    libXrandr
    libXi
    libXext
    libXcomposite
    libXdamage
    libXfixes
    libXScrnSaver
  ]);

  zen = pkgs.stdenv.mkDerivation {
    name = "zen";
    phases = [ "installPhase" "fixupPhase" ];
    nativeBuildInputs = [ pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook ];

    # GDK_SCALE= GDK_DPI_SCALE= ~/.nix-profile/bin/zen
    installPhase = ''
      mkdir -p $out/{bin,opt/zen}
      cp -r ${src}/* $out/opt/zen
      ln -s $out/opt/zen/zen $out/bin/zen

      install -D ${src}/browser/chrome/icons/default/default16.png $out/share/icons/hicolor/16x16/apps/zen.png
      install -D ${src}/browser/chrome/icons/default/default32.png $out/share/icons/hicolor/32x32/apps/zen.png
      install -D ${src}/browser/chrome/icons/default/default48.png $out/share/icons/hicolor/48x48/apps/zen.png
      install -D ${src}/browser/chrome/icons/default/default64.png $out/share/icons/hicolor/64x64/apps/zen.png
      install -D ${src}/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen.png
    '';

    fixupPhase = ''
      chmod 755 $out/bin/zen $out/opt/zen/*

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/zen
      wrapProgram $out/opt/zen/zen --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
        --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/zen-bin
      wrapProgram $out/opt/zen/zen-bin --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
        --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/glxtest
      wrapProgram $out/opt/zen/glxtest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/updater
      wrapProgram $out/opt/zen/updater --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"

      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/vaapitest
      wrapProgram $out/opt/zen/vaapitest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
    '';
  };
in
{
  options.dots.zen = {
    enable = mkEnableOption "enable zen";
  };

  config = mkIf cfg.enable
    {
      home.packages = [ zen zen-unscaled ];
    };
}
