{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.settings = {
          binds = {
            # https://github.com/hyprwm/Hyprland/pull/352/files
            workspace_back_and_forth = false;
            hide_special_on_workspace_change = true;
            allow_workspace_cycles = true;
            workspace_center_on = 1;
          };
          bind = [
            # Switch to previous workspace
            "SUPER, A, workspace, previous"

            # Cycle through active workspaces
            "SUPER, Right, workspace, e+1"
            "SUPER, Left,  workspace, e-1"

            # Switch workspaces with SUPER + [0-9]
            "SUPER, 1, workspace,  1"
            "SUPER, 2, workspace,  2"
            "SUPER, 3, workspace,  3"
            "SUPER, 4, workspace,  4"
            "SUPER, 5, workspace,  5"
            "SUPER, 6, workspace,  6"
            "SUPER, 7, workspace,  7"
            "SUPER, 8, workspace,  8"
            "SUPER, 9, workspace,  9"
            "SUPER, 0, workspace, 10"

            # Move active window to a workspace with SUPER + SHIFT + [0-9]
            "SUPER SHIFT, 1, movetoworkspacesilent,  1"
            "SUPER SHIFT, 2, movetoworkspacesilent,  2"
            "SUPER SHIFT, 3, movetoworkspacesilent,  3"
            "SUPER SHIFT, 4, movetoworkspacesilent,  4"
            "SUPER SHIFT, 5, movetoworkspacesilent,  5"
            "SUPER SHIFT, 6, movetoworkspacesilent,  6"
            "SUPER SHIFT, 7, movetoworkspacesilent,  7"
            "SUPER SHIFT, 8, movetoworkspacesilent,  8"
            "SUPER SHIFT, 9, movetoworkspacesilent,  9"
            "SUPER SHIFT, 0, movetoworkspacesilent, 10"
          ];
        };
      };
    };
}
