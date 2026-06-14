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
          workspace_rule = [
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
              on_created_empty = "doom-emacs";
            }
          ];
          bind = (
            {
              # Cycle previous
              "SUPER + bracketleft" = "cycleprev";

              # Cycle next
              "SUPER + bracketright" = "cyclenext";
            }
            |> lib.mapAttrsToList (
              keys: msg: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline ''hl.dsp.layout("${msg}")'')
                ];
              }
            )
          );
        };
      };
    };
}
