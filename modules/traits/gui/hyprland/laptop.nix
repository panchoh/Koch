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
          lib.optionals
            (nixosConfig.hardware.facter.report.hardware.system.system.form_factor or { } == "laptop")
            [
              {
                workspace = "name:coding";
                monitor = "eDP-1";
                default = true;
                layout = "monocle";
                persistent = true;
                gaps_in = 0;
                gaps_out = 0;
                no_border = true;
                no_rounding = true;
                decorate = false;
                on_created_empty =
                  let
                    singleMonitor = builtins.length (nixosConfig.hardware.facter.report.hardware.monitor or [ ]) == 1;
                  in
                  if singleMonitor then
                    "doom-emacs"
                  else
                    ''hyprctl monitors -j | jq --raw-output --exit-status 'any(.[]; .name | test("^DP-[0-9]$"))' > /dev/null || doom-emacs'';
              }
            ];
      };
    };
}
