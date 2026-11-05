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

        wayland.windowManager.hyprland =
          let
            facterHardwareReport = nixosConfig.hardware.facter.report.hardware;
            isLaptop = facterHardwareReport.system.form_factor or { } == "laptop";
            singleMonitor = builtins.length (facterHardwareReport.monitor or [ ]) == 1;
            multiMonitor = builtins.length (facterHardwareReport.monitor or [ ]) > 1;
            externalMonitorCheckCmd = ''hyprctl monitors -j | jq --exit-status --raw-output 'any(.[]; .name | test("^DP-[0-9]$"))' > /dev/null'';
          in
          {

            extraConfig =
              if singleMonitor then
                ''workspace_programs["Doom!"] = { "doom-emacs", {} }''
              else
                ''workspace_programs["Doom!"] = { [[${externalMonitorCheckCmd} || doom-emacs]], {} }'';

            settings.workspace_rule = lib.optionals (isLaptop && multiMonitor) [
              {
                workspace = "Doom!";
                monitor = "eDP-1";
                default = true;
                persistent = true;
                layout = "monocle";
              }
            ];
          };
      };
    };
}
