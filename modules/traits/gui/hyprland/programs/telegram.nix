{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          pkgs.telegram-desktop
        ];
        xdg.mimeApps.defaultApplications =
          [
            "x-scheme-handler/tg"
            "x-scheme-handler/tonsite"
          ]
          |> lib.flip lib.attrsets.genAttrs (_scheme: "telegram.desktop.desktop");

        wayland.windowManager.hyprland.settings = {
          workspace_rule = [
            {
              workspace = "special:Telegram";
              on_created_empty = "Telegram";
            }
          ];
          window_rule = [
            {
              match.class = "^org\\.telegram\\.desktop$";
              workspace = "special:Telegram silent";
            }
          ];
          bind =
            {
              # Select to special:Telegram workspace
              "SUPER + Minus" = ''hl.dsp.workspace.toggle_special("Telegram")'';

              # Move to special:Telegram workspace
              "SUPER + SHIFT + Minus" = ''hl.dsp.window.move({ workspace = "special:Telegram" })'';
            }
            |> lib.mapAttrsToList (
              keys: dispatcher: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline dispatcher)
                ];
              }
            );
        };
      };
    };
}
