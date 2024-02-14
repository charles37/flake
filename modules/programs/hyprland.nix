#{ pkgs, config, lib, inputs, ... }:
#
#let
#    hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
#in with lib; {
#    wayland.windowManager.hyprland = {
#        enable = true;
#        xwayland.enable = true;
#        systemd.enable = true;
#        plugins = [
#            hyprlandPlugins.hyprbars
#        ];
#        settings = {
#            "$mod" = "SUPER";
#            bind =
#              [
#                "$mod, F, exec, firefox"
#                "$mod, Q, exec, kitty"
#                "$mod, A, exec, alacritty"
#                "$mod, A, exec, chromium"
#                ", Print, exec, grimblast copy area"
#              ]
#              ++ (
#                # workspaces
#                # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
#                builtins.concatLists (builtins.genList (
#                    x: let
#                      ws = let
#                        c = (x + 1) / 10;
#                      in
#                        builtins.toString (x + 1 - (c * 10));
#                    in [
#                      "$mod, ${ws}, workspace, ${toString (x + 1)}"
#                      "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
#                    ]
#                  )
#                  10)
#              );
#
#        };
#    };
#
#}
#

{ pkgs, config, lib, inputs, ... }:

let
  hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
in with lib; {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    plugins = [
      hyprlandPlugins.hyprbars
    ];
    settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, Q, exec, kitty"
        "$mod, A, exec, alacritty"
        "$mod, C, exec, chromium"
        ", Print, exec, grimblast copy area"
        "$mod, SPACE, exec, rofi -show drun"
        "$mod SHIFT, S, exec, systemctl suspend"
        "$mod SHIFT, R, exec, systemctl reboot"
        "$mod SHIFT, E, exec, systemctl poweroff"
        "$mod, X, exec, swaylock"
# Volume
        "$mod, Up, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        "$mod, Down, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        "$mod, M, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
# Brightness
        "$mod, F1, exec, light -U 10  # Decrease brightness"
        "$mod, F2, exec, light -A 10  # Increase brightness"
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

