
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  user = "ben";
#  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };confi
  #apk-mitm-package = import ../customPackages/apk-mitm/default.nix { inherit pkgs; };
in

{


  imports =
    (import ../modules/rootLevelPrograms) ++ [
      ./hardware-configuration.nix
      # Include the results of the hardware scan.
    ];
  

  # nix Settings
  nix = { 
    # Flake Settings
    settings.experimental-features = [ "nix-command" "flakes" ];
    package = pkgs.nixFlakes;

    # Garbage Collection
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "montly";
      options = "--delete-older-than 30d";
    };
    settings.substituters = [ "https://cache.nixos.org/" "https://nix-node.cachix.org/" ];
    registry."node".to = {
      type = "github";
      owner = "andyrichardson";
      repo = "nix-node";
    };
  };


  # Bootloader.
  boot.loader.systemd-boot.enable = true; #true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "marin"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
 
  # Enable postgres Server
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
      CREATE DATABASE nixcloud;
      GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    '';
  };

 # https://discourse.nixos.org/t/cant-get-gnupg-to-work-no-pinentry/15373/2
 # https://git.hrnz.li/Ulli/nixos/commit/156e7034ffa5aecc4097628394cc47d26413a0e7
  services.dbus.packages = with pkgs; [ gcr xdg-desktop-portal-gnome pipewire ];


  # MAYBE remove the above?


  #programs.sway.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  security.polkit.enable = true;
  
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

    
  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  hardware.opengl.enable = true; # for hyprland

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  #hardware.pulseaudio.enable = true; # for hyprland
  # services.mullvad-vpn.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver.displayManager.sessionCommands = ''
    # Start the gnome-keyring-daemon
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
  '';

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  #services.xserver = {
  #    enable = true;
  #    # Configure keymap in X11
  #    xkb = {
  #      layout = "us";
  #      variant = "";
  #    };
  #    displayManager.lightdm.enable = true;
  #    videoDrivers = ["nvidia"];
  #  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user}= {
    isNormalUser = true;
    description = "ben";
    extraGroups = [ "networkmanager" "wheel" "docker" "wireshark" "adbusers"];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.pulseaudio = true;
  
  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-14.21.3"
    "openssl-1.1.1w"
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [

  ];

  # adb for android
  programs.adb.enable = true;

  programs.dconf.enable = true;

  programs.wireshark.enable = true;
#  services.pcscd.enable = true;
#  programs.gnupg = {
#     enable = true;
#     pinentryFlavor = "gnome3";
#     enableSSHSupport = true;
#  };

  # Enable Hyprland 
  programs.hyprland = {
    enable = true;
    # vvv apparently this is no longer needed vvv
    #nvidiaPatches = true;
    xwayland = {
      enable = true;
      #enableGpuAcceleration = true;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Enable Docker service
  virtualisation.docker.enable = true; 

  #Enable Waydroid service
  virtualisation.waydroid.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    haskellPackages = pkgs.haskellPackages.override {
      overrides = self: super: {
        zlib = super.zlib.overrideAttrs (oldAttrs: {
          configureFlags = oldAttrs.configureFlags ++ [ "--extra-include-dirs=${pkgs.zlib.dev}/include" "--extra-lib-dirs=${pkgs.zlib.out}/lib" ];
        });
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    unetbootin # for creating bootable USB drives
    networkmanager
    protonvpn-cli_2
    freerdp
    xrdp
    zulu #Java for React-Native start
    vim_configurable # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vimPlugins.vim-nix
    gnome.adwaita-icon-theme
    pulseaudio
    pavucontrol
    wget
    ripgrep
    ssh-askpass-fullscreen
    deno
    lua
    luajitPackages.lua-lsp
    postgresql
    androidStudioPackages.dev
    chromium
    # Rust stuff
    rust-analyzer
    rustc
    cargo
    cargo-watch
    rustfmt
    cargo-tarpaulin
    clippy
    pkg-config
    openssl
    wireshark
    #mullvad-vpn
    protonvpn-gui
    nodejs_20
    cabal-install
    haskellPackages.zlib
    zlib
    zlib.dev 
    zlib.out 
    pkg-config
    libclang
    ccls
    bear
    sbcl
    roswell
    charles
    #HYPRLAND
    gtk3
    rofi-wayland
    (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    ) # from https://www.youtube.com/watch?v=61wGzIv12Ds&t=74s
    wl-clipboard
    mako
    libnotify
    bemenu
    fuzzel
    tofi
    swww
    brightnessctl
    gnome.gnome-keyring


    # qmk
    vial


    

  ];

  environment.sessionVariables = {
    #invisible cursor
    WLR_NO_HARDWARE_CURSORS = "1";
    # have electron apps use wayland
    NIXOS_OZONE_WL = "1";
  };



  # virtualbox 
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "ben" ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "nixos-unstable"; # Did you read the comment?

#  Home-Manager module mode

#  home-manager.users.${user} = { pkgs, ...}: {
#    home.packages = with pkgs; [ 
#      htop
#    ];
#    home.stateVersion = "22.11";
#  };

}
