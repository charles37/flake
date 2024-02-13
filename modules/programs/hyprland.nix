{ pkgs, config, lib, inputs, ... }:

let
    hyprlandPlugins = inputs.hyprland-plugins.packages.${pkgs.system};
in with lib; {
    wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.enable = true;
        plugins = [
        ];
    };
}
