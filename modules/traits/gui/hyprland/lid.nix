{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:

      let
        cfg = config.traits.os.hyprland;
      in
      {
        config = lib.mkIf cfg.enable {
          services.logind.settings.Login = {
            # See logind.conf(5)
            # HandleLidSwitchDocked = "ignore"; # default value
            HandleLidSwitchExternalPower = "ignore";
          };
        };
      };

    homeModules.default =
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
          # Lid management
          # https://www.reddit.com/r/hyprland/comments/1tbugwn/disabling_monitor_using_keybinds_in_055/
          # https://wiki.hypr.land/Configuring/Basics/Binds/#switches
          # https://github.com/hyprwm/Hyprland/discussions/11093
          wayland.windowManager.hyprland = {

            settings.bind =
              {
                "switch:on:Lid Switch" = "true";
                "switch:off:Lid Switch" = "false";
              }
              |> lib.mapAttrsToList (
                keys: disabled: {
                  _args = [
                    keys
                    (lib.generators.mkLuaInline ''
                      function()
                        hl.monitor({ output = "eDP-1", disabled = ${disabled} })
                      end
                    '')
                    { locked = true; }
                  ];
                }
              );

            extraConfig = lib.optionalString box.hasExternalMonitor or false ''
              hl.on("monitor.layout_changed", function()
                  local internal_enabled = hl.get_monitor("eDP-1")
                  local monitors = hl.get_monitors()
                  local should_disable = #monitors > 1 and monitors[1].name ~= "FALLBACK"
                  local should_enable = monitors[1] and monitors[1].name == "FALLBACK"

                  if internal_enabled and should_disable then
                      hl.monitor({output = "eDP-1", disabled = true })
                  elseif not internal_enabled and should_enable then
                      hl.monitor({output = "eDP-1", disabled = false })
                  end
              end)
            '';
          };
        };
      };
  };
}
