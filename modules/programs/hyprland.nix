{ pkgs, config, lib, inputs, ... }:

let
  hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
  

in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      #hyprlandPlugins.hyprbars
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
        ", Print, exec, grimshot --notify save screen ~/Pictures/Screenshots/$(TZ=utc date +'screenshot_%Y-%m-%d-%H%M%S.%3N.png')"
        "$mod, Print, exec, grimshot --notify save area ~/Pictures/Screenshots/$(TZ=utc date +'screenshot_%Y-%m-%d-%H%M%S.%3N.png')"
#        "$mod, Alt, Print, exec, grimshot --notify save active ~/Pictures/Screenshots/$(TZ=utc date +'screenshot_%Y-%m-%d-%H%M%S.%3N.png')"

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

