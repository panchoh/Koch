{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.settings = {
          # REVIEW: https://github.com/hyprwm/Hyprland/discussions/15047
          # Currently, default workspace gets ID 2, not 1
          workspace_rule = [
            {
              workspace = 1;
              monitor = if box.hasExternalMonitor or false then box.externalMonitorID or "DP-2" else "DP-1";
              default = true;
              default_name = "Doom";
              on_created_empty =
                if (box.isLaptop or false) && (box.hasExternalMonitor or false) then
                  ''hyprctl monitors -j | jq --raw-output --exit-status 'any(.[]; .name | test("^DP-[0-9]$"))' > /dev/null && doom-emacs''
                else
                  "doom-emacs";
            }
          ];

          window_rule = [
            {
              # https://github.com/hyprwm/Hyprland/issues/3073
              name = "honor-focus-events-for-emacs-windows";
              match.initial_class = "^emacs$";
              focus_on_activate = true;
            }
          ];

          bind =
            {
              "SUPER + D" = "doom-emacs";
              "SUPER + E" = "emacs";
              "SUPER + SHIFT + E" = "emacsclient --no-wait --reuse-frame";
            }
            |> lib.mapAttrsToList (
              keys: editor: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${editor}")'')
                ];
              }
            );
        };
      };
    };
}
