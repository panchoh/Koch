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
        wayland.windowManager.hyprland.settings.workspace_rule =
          let
            facterHardwareReport = nixosConfig.hardware.facter.report.hardware;
            isLaptop = facterHardwareReport.system.form_factor or { } == "laptop";
            singleMonitor = builtins.length (facterHardwareReport.monitor or [ ]) == 1;
            multiMonitor = builtins.length (facterHardwareReport.monitor or [ ]) > 1;
          in
          lib.optionals (isLaptop && multiMonitor) [
            {
              workspace = 42;
              monitor = "eDP-1";
              default = true;
              default_name = "Doom";
              persistent = true;
              layout = "monocle";
              on_created_empty =
                if singleMonitor then
                  "doom-emacs"
                else
                  ''hyprctl monitors -j | jq --exit-status --raw-output 'any(.[]; .name | test("^DP-[0-9]$"))' > /dev/null || doom-emacs'';
            }
          ];
      };
    };
}
