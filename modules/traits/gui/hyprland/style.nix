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
        wayland.windowManager.hyprland.settings = {
          animation = [
            {
              leaf = "windows";
              enabled = true;
              speed = 8;
              bezier = "default";
              style = "popin 80%";
            }
          ];
          config = {
            animations.enabled = true;
            general = {
              border_size = 2;
              # https://github.com/dracula/draculatheme.com/blob/main/content/spec.mdx
              "col.active_border" = lib.mkForce (
                # Color Palette > Pink
                # UI Color Palette > Functional Colors > Functional Purple : Focus indicators
                lib.generators.mkLuaInline ''{ colors = { "rgba(ff79c6ee)", "rgba(815cd6ee)" }, angle = 45 }''
              );
            };
            decoration = {
              rounding = 5;
              dim_around = 0.66;
              dim_inactive = true;
              dim_strength = 0.15;
            };
            misc = {
              # https://wiki.hypr.land/Configuring/Basics/Variables/#misc
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              force_default_wallpaper = 2;
            };
          };
          window_rule = [
            {
              # Ignore maximize requests from all apps. You'll probably like this.
              name = "suppress-maximize-events";
              match.class = ".*";

              suppress_event = "maximize";
            }
            {
              # Fix some dragging issues with XWayland
              name = "fix-xwayland-drags";
              match = {
                class = "^$";
                title = "^$";
                xwayland = true;
                float = true;
                fullscreen = false;
                pin = false;
              };

              no_focus = true;
            }
          ];
          bind = [
            {
              _args = [
                "SUPER + F1"
                (lib.generators.mkLuaInline ''
                  function ()
                    local game_mode = (hl.get_config("animations.enabled") == false)

                    if game_mode then
                        hl.exec_cmd("hyprctl reload")
                        return
                    end

                    hl.config({
                        general = {
                            gaps_in = 0, gaps_out = 0, -- Disable gaps
                            border_size = 0,
                        },

                        animations = {
                            enabled = false, -- Disable animations
                        },

                        -- Disable blur, shadow and window rounding
                        decoration = {
                            shadow = { enabled = false },
                            blur = { enabled = false },
                            rounding = 0,
                        }
                    })
                  end
                '')
              ];
            }
          ];
        };
      };
    };
}
