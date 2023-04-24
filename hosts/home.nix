{ config, lib, pkgs, system, ... }:
let
  fix-and-rebuild = (pkgs.writeShellScriptBin "frb" ''
      #!/bin/sh
      ${pkgs.bash}/bin/bash ${toString ./.}/scripts/frb "''${1}"
    '');
  generic = import ../modules/programs/generic.nix;
  signal-desktop-alt = generic {
    pname = "signal-desktop";
    dir = "Signal";
    version = "6.10.0";
    hash = "sha256-QEbhRK9i1qjE3oUKz2iadTzJNCdgEL8/OQyBo2iK4wo=";
    inherit lib;
    inherit (pkgs) xorg stdenv fetchurl;
    inherit (pkgs.buildPackages) autoPatchelfHook dpkg wrapGAppsHook makeWrapper;
    inherit (pkgs) nixosTests gtk3 atk at-spi2-atk cairo pango gdk-pixbuf glib freetype
      fontconfig dbus nss
      nspr alsa-lib cups expat libuuid at-spi2-core libappindicator-gtk3 mesa
      systemd libnotify libdbusmenu libpulseaudio xdg-utils wayland;
    inherit (pkgs.xorg) libX11 libXi libXcursor libXdamage libXrandr
      libXcomposite libXext libXfixes libXrender libXtst libXScrnSaver;

  };
in
{
  imports = 
    (import ../modules/programs); # ++ (import ../modules/services);

  # Home Manager needs a bit of information about you and the
  # paths it should manage.


  home = {
    username = "ben";
    homeDirectory = "/home/ben";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.

    stateVersion = "22.11";
    packages = with pkgs; [
      htop
      alacritty
      signal-desktop-alt
      fix-and-rebuild
    ];
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # fix for https://github.com/nix-community/home-manager/issues/3342
  manual.manpages.enable = false; 
  
  # Git Config
  programs.git = {
    enable = true;
    userName = "charles37";
    userEmail = "benprevor@gmail.com";
  };

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "file://" + ../wallpapers/purple-anime-girl.jpg;
    };
  };

  home.file = {
    ".config/alacritty/alacritty.yml".text = builtins.readFile(../modules/programs/alacritty/alacritty.yml);
  };

}
