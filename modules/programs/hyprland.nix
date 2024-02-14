{ pkgs, config, lib, inputs, ... }:

let
    hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
in with lib; {
    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        enableNvidiaPatches = true;
        systemd.enable = true;
        plugins = [
            hyprlandPlugins.hyprbars
        ];
        settings = {
            "$mod" = "SUPER";
            bind =
              [
                "$mod, F, exec, firefox"
                ", Print, exec, grimblast copy area"
              ]
              ++ (
                # workspaces
                # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
                builtins.concatLists (builtins.genList (
                    x: let
                      ws = let
                        c = (x + 1) / 10;
                      in
                        builtins.toString (x + 1 - (c * 10));
                    in [
                      "$mod, ${ws}, workspace, ${toString (x + 1)}"
                      "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                    ]
                  )
                  10)
              );

        };
    };

}
