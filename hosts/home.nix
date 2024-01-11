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

  stack-wrapped = pkgs.symlinkJoin {
    name = "stack";
    paths = [ pkgs.stack ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/stack \
        --add-flags "\
          --nix \
          --no-nix-pure \
          --nix-shell-file=nix/stack-integration.nix \
        "
    '';
  };

  customNodejs = pkgs.nodejs.override {
    enableNpm = true;
    version = "14.19.1";
    sha256 = "1ncxpal08rza4ydbwhsmn6v85padll7mrfw38kq9mcqshvfhkbp1";
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
    stateVersion = "23.11";

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.

    packages = with pkgs; [
      zoom-us
      microsoft-edge-dev
      texlive.combined.scheme-tetex
      texstudio
      # haskell.compiler.ghc944
      haskellPackages.zlib 
      haskell-language-server
      cabal-install
      haskellPackages.ghcid
      stack
      htop
      alacritty
      signal-desktop
      fix-and-rebuild
      nodePackages_latest.pyright
      watchman
      gcc9
      cling
      rnix-lsp
      sumneko-lua-language-server
      purescript
      nodePackages_latest.purescript-language-server
      watchman
      whatsapp-for-linux
      docker
      elmPackages.elm
      elmPackages.elm-language-server
      elmPackages.elm-live
      xclip
      toml2json
      jq
      libpqxx
      pinentry-gnome
      gnupg
      python3
      libreoffice-still
      vscode-langservers-extracted
      steam
      qmk
      heroku
      slack
      vial
      signal-cli
      mullvad-browser
      wgnord
      expressvpn
      idris2
      # customNodejs
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };

  programs.gpg = { homedir = "${config.xdg.dataHome}/gnupg"; };


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
      picture-uri = "file://" + ../wallpapers/purple-anime-girl.png;
      picture-uri-dark = "file://" + ../wallpapers/purple-anime-girl.png;
 
    };
  };

  home.file = {
    ".config/alacritty/alacritty.toml".text = builtins.readFile(../modules/programs/alacritty/alacritty.toml);
  };

}
