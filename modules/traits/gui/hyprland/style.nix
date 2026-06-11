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
              "col.active_border" = lib.mkForce (
                lib.generators.mkLuaInline ''{ colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 }''
              );
              "col.inactive_border" = lib.mkForce (
                lib.generators.mkLuaInline ''{ colors = { "rgba(595959aa)" } }''
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
        };
      };
    };
}
