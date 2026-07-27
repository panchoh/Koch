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

            -- Tracks Hyprland’s internal cycle direction.
            -- Must be updated whenever we request a direction flip.
            local cycling_forward = true

            local function cycle(opts)
                opts = opts or {}

                local backward = opts.backward == true
                local forward = not backward

                local needs_flipping = forward ~= cycling_forward

                if needs_flipping then
                    cycling_forward = forward
                end

                hl.dispatch(hl.dsp.window.cycle_next({ next = not needs_flipping }))
                hl.dispatch(hl.dsp.window.bring_to_top())
                hl.dispatch(hl.dsp.layout("fit_into_view"))
            end

            local function cycle_backward()
                cycle({ backward = true })
            end

            local function cycle_forward()
                cycle()
            end

            -- Shared per-direction action tables, so the two binds for each
            -- direction (Tab-family + bracket-family) can’t drift out of sync.
            local forward_actions = {
                scrolling = cycle_forward,
                monocle = hl.dsp.layout("cyclenext"),
            }

            local backward_actions = {
                scrolling = cycle_backward,
                monocle = hl.dsp.layout("cycleprev"),
            }

            hl.bind("SUPER + SHIFT + Tab", layout_bind(backward_actions))
            hl.bind("SUPER + bracketleft", layout_bind(backward_actions))

            hl.bind("SUPER + Tab", layout_bind(forward_actions))
            hl.bind("SUPER + bracketright", layout_bind(forward_actions))
          '';
        };
      };
    };
}
