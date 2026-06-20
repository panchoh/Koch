{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#cycle-layout-for-current-workspace
        wayland.windowManager.hyprland.settings.bind = [
          {
            _args = [
              "SUPER + CONTROL + Space"
              (lib.generators.mkLuaInline ''
                function ()
                    local layouts     = { "scrolling", "monocle" }
                    local workspace   = hl.get_active_workspace()
                    if hl.get_active_special_workspace() then
                        workspace = hl.get_active_special_workspace()
                    end

                    local next_layout = "dwindle"

                    if not workspace then
                        return
                    end

                    for i = 1, #layouts do
                        if layouts[i] == workspace.tiled_layout then
                            local next_layout_idx = (i % #layouts) + 1
                            next_layout = layouts[next_layout_idx]
                            break
                        end
                    end

                    if workspace.special then
                        hl.workspace_rule({ workspace = tostring(workspace.name), layout = next_layout })
                    else
                        hl.workspace_rule({ workspace = tostring(workspace.id), layout = next_layout })
                    end
                end
              '')
            ];
          }
        ];
      };
    };
}
