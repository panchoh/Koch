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
        wayland.windowManager.hyprland = {
          # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#per-layout-bindings
          # https://wiki.hypr.land/Configuring/Basics/Binds/#multiple-binds-to-one-key
          extraConfig = ''
            local function layout_bind(bind_table)
                return function ()
                    local workspace = hl.get_active_special_workspace() or
                                      hl.get_active_workspace()

                    if not workspace then
                        return
                    end

                    local layout = workspace.tiled_layout

                    if bind_table[layout] then
                        hl.dispatch(bind_table[layout])
                    end
                end
            end

            hl.bind("SUPER + SHIFT + Tab", layout_bind({
                scrolling = function()
                    hl.dispatch(hl.dsp.window.cycle_prev())
                    hl.dispatch(hl.dsp.window.bring_to_top())
                end,
                monocle = hl.dsp.layout("cycleprev")
            }))

            hl.bind("SUPER + bracketleft", layout_bind({
                scrolling = function()
                    hl.dispatch(hl.dsp.window.cycle_prev())
                    hl.dispatch(hl.dsp.window.bring_to_top())
                end,
                monocle = hl.dsp.layout("cycleprev")
            }))

            hl.bind("SUPER + Tab", layout_bind({
                scrolling = function()
                    hl.dispatch(hl.dsp.window.cycle_next())
                    hl.dispatch(hl.dsp.window.bring_to_top())
                end,
                monocle = hl.dsp.layout("cyclenext")
            }))

            hl.bind("SUPER + bracketright", layout_bind({
                scrolling = function()
                    hl.dispatch(hl.dsp.window.cycle_next())
                    hl.dispatch(hl.dsp.window.bring_to_top())
                end,
                monocle = hl.dsp.layout("cyclenext")
            }))
          '';
        };
      };
    };
}
