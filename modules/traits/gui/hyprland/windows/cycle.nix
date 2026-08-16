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

        # https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#per-layout-bindings
        # https://wiki.hypr.land/Configuring/Basics/Binds/#multiple-binds-to-one-key
        wayland.windowManager.hyprland.extraConfig = ''
          local function layout_bind(bind_table)
              return function ()
                  local workspace = hl.get_active_special_workspace() or
                                    hl.get_active_workspace()

                  if not workspace then
                      return
                  end

                  local action = bind_table[workspace.tiled_layout]

                  if type(action) == "function" then
                      action(workspace)
                  elseif action then
                      hl.dispatch(action)
                  end
              end
          end

          -- Tracks Hyprland’s internal cycle direction, per workspace
          -- (regular and special workspaces use disjoint id ranges, confirmed
          -- via `hyprctl repl`, so a flat table keyed on id is safe).
          -- Must be updated whenever we request a direction flip on that workspace.
          local cycling_forward_by_workspace = {}

          local function cycle(workspace, opts)
              opts = opts or {}

              local backward = opts.backward == true
              local forward = not backward

              local ws_id = workspace.id
              local cycling_forward = cycling_forward_by_workspace[ws_id]

              if cycling_forward == nil then
                  cycling_forward = true
              end

              local needs_flipping = forward ~= cycling_forward

              if needs_flipping then
                  cycling_forward_by_workspace[ws_id] = forward
              end

              hl.dispatch(hl.dsp.window.cycle_next({ next = not needs_flipping }))
              hl.dispatch(hl.dsp.window.bring_to_top())
              hl.dispatch(hl.dsp.layout("fit_into_view"))
          end

          local function cycle_backward(workspace)
              cycle(workspace, { backward = true })
          end

          local function cycle_forward(workspace)
              cycle(workspace)
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
}
