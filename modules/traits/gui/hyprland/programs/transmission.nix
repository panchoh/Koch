{
  flake.nixosModules.default =
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
        networking.firewall.allowedTCPPorts = [ 51413 ];
      };
    };

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
          pkgs.transmission_4-gtk
        ];
        xdg.mimeApps.defaultApplications."x-scheme-handler/magnet" = "transmission-gtk.desktop";
        wayland.windowManager.hyprland.settings = {
          workspace_rule = [
            {
              workspace = "special:Transmission";
              on_created_empty = "transmission-gtk";
            }
          ];
          window_rule = [
            {
              match = {
                class = "^(transmission-gtk)$";
                title = "^(Transmission)$";
              };
              workspace = "special:Transmission silent";
            }
            {
              match = {
                class = "^(transmission-gtk)$";
                title = "^(Torrent Options)$";
              };
              center = true;
            }
          ];
          bind =
            {
              # Select to special:Transmission workspace
              "SUPER + Equal" = ''hl.dsp.workspace.toggle_special("Transmission")'';

              # Move to special:Telegram workspace
              "SUPER + SHIFT + Equal" = ''hl.dsp.window.move({ workspace = "special:Transmission" })'';
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
