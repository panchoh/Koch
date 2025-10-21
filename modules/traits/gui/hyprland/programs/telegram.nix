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
          workspace = [
            "special:Telegram, on-created-empty: Telegram"
          ];
          bind = [
            # Select / Move to special:Telegram workspace
            "SUPER,       Minus, togglespecialworkspace,         Telegram"
            "SUPER SHIFT, Minus, movetoworkspacesilent,  special:Telegram"
          ];
          windowrulev2 = [
            "float,                             class:^(org.telegram.desktop)$, title:^(Media viewer)$"
            "workspace special:Telegram silent, class:^(org.telegram.desktop)$"
          ];
        };
      };
    };
}
