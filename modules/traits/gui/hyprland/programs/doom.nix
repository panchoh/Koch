{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        wayland.windowManager.hyprland.settings = {

          # REVIEW: https://github.com/hyprwm/Hyprland/discussions/15047
          # Currently, default workspace gets ID 2, not 1
          workspace_rule =
            let
              facterHardwareReport = nixosConfig.hardware.facter.report.hardware;
              isLaptop = facterHardwareReport.system.form_factor or { } == "laptop";
              isDesktop = facterHardwareReport.system.form_factor or { } == "desktop";
              singleMonitor = builtins.length (facterHardwareReport.monitor or [ ]) == 1;
              multiMonitor = builtins.length (facterHardwareReport.monitor or [ ]) > 1;
              gpus = facterHardwareReport.graphics_card or [ ];
              hasNvidia = builtins.any (gpu: (gpu.vendor.name or "") == "nVidia Corporation") gpus;
            in
            lib.optionals (isDesktop || (isLaptop && multiMonitor)) [
              {
                workspace = 1;
                monitor =
                  if hasNvidia then
                    "HDMI-A-1"
                  else if singleMonitor then
                    "DP-1"
                  else
                    "DP-2";
                default = true;
                default_name = "Doom";
                on_created_empty =
                  if singleMonitor then
                    "doom-emacs"
                  else
                    ''hyprctl monitors -j | jq --exit-status --raw-output 'any(.[]; .name | test("^DP-[0-9]$"))' > /dev/null && doom-emacs'';
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
