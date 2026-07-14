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
          pkgs.grim
          pkgs.grimblast
          pkgs.hyprpicker
          pkgs.jq
          pkgs.libnotify # for notify-send
          pkgs.slurp
          pkgs.wl-clipboard # for wl-copy and wl-paste
          # REVIEW
          # pkgs.wl-clipboard-rs
        ];
        programs.satty = {
          enable = true;
          settings.general = {
            floating-hack = true;
            default-hide-toolbars = true;
            focus-toggles-toolbars = true;
            actions-on-enter = [
              "save-to-file"
              "exit"
            ];
            output-filename = "${config.xdg.userDirs.extraConfig.SCREENSHOTS}/test-%Y-%m-%d_%H:%M:%S.png";
          };
        };
        wayland.windowManager.hyprland.settings.bind =
          {
            "Print" = "active";
            "SHIFT + Print" = "screen";
            "ALT + Print" = "output";
            "CONTROL + Print" = "area";
            # https://youtu.be/mZSFA7vUEnI
            # https://github.com/Satty-org/Satty
            "SUPER + Print" = "area - | satty --filename -";
          }
          |> lib.mapAttrsToList (
            keys: scope: {
              _args = [
                keys
                #  https://github.com/hyprwm/contrib/blob/main/grimblast/grimblast
                (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("grimblast save ${scope}")'')
              ];
            }
          );
      };
    };
}
