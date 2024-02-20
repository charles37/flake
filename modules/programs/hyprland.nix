{ pkgs, config, lib, inputs, ... }:

let
  hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
  grimPath = pkgs.grim;
  slurpPath = pkgs.slurp;
  grimShotPath = pkgs.sway-contrib.grimshot;
in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      hyprlandPlugins.hyprbars
    ];
    settings = {
      exec-once = [ 
        "waybar"
        "mako"
      ];
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
      };
      #input = {
      #  #natural_scroll = true;
      #};
      "$mod" = "SUPER";
      "monitor" = "DP-1,1920x1080,0x0,1";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, Q, exec, kitty"
        "$mod, A, exec, alacritty"
        "$mod, X, exec, chromium"
        "$mod, C, killactive"
        ", Print, exec, grimblast copy area"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod SHIFT, S, exec, systemctl suspend"
        "$mod SHIFT, R, exec, systemctl reboot"
        "$mod SHIFT, E, exec, systemctl poweroff"
        # Volume
        "$mod, Up, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "$mod, Down, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "$mod, M, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        # Brightness
        "$mod, F5, exec, brightnessctl -d intel_backlight s 10%-"
        "$mod, F6, exec, brightnessctl -d intel_backlight s +10%"
        # Screenshots
        "$mod, P, exec, grimshot save"
        "$mod SHIFT, P, exec, grimshot copy" 
        "$mod SHIFT, Print, exec, ${grimShotPath} ~/Pictures/Screenshots/$(date +'%s_grim.png')"
        # Additional keybindings for window resizing and movement could be added here
      ] ++ (
        # workspaces and window management
        builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            # Add here rules for floating windows, resizing, and moving if needed
          ]
        ) 10)
      );
    };
  };
}

