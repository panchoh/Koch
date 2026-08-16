{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        home.packages = [

          # For notify-send, used by programs.foot.settings.desktop-notifications.command’s default value
          pkgs.libnotify
        ];

        programs.foot = {

          enable = true;
          server.enable = true;

          settings = {
            bell = {
              urgent = true;
              notify = true;
              visual = true;
            };

            main.pad = "0x0";
            mouse.hide-when-typing = true;
          };
        };

        wayland.windowManager.hyprland.settings = {

          animation = [
            {
              leaf = "specialWorkspace";
              enabled = true;
              speed = 8;
              bezier = "default";
              style = "slidefadevert 20%";
            }
          ];

          workspace_rule = [
            {
              workspace = "special:Foot";
              on_created_empty = "foot";
            }
          ];

          bind = [
            {
              _args = [
                "SUPER + SUPER_L"
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("footclient")'')
                { release = true; }
              ];
            }
          ]
          ++ (
            {
              # "SUPER + SHIFT + Return" = ''hl.dsp.exec_cmd("footclient")'';
              "SUPER + grave" = ''hl.dsp.workspace.toggle_special("Foot")'';
              "SUPER + SHIFT + grave" = ''hl.dsp.window.move({ workspace = "special:Foot" })'';
              "SUPER + CONTROL + grave" = ''hl.dsp.window.move({ workspace = "special:Foot", follow = false })'';
            }
            |> lib.mapAttrsToList (
              keys: dispatcher: {
                _args = [
                  keys
                  (lib.generators.mkLuaInline dispatcher)
                ];
              }
            )
          );
        };
      };
    };
}
