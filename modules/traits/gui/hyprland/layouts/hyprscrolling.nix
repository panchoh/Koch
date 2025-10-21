{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {

        wayland.windowManager.hyprland = {
          plugins = [
            pkgs.hyprlandPlugins.hyprscrolling
          ];

          settings = {
            general.layout = "scrolling";

            # https://github.com/hyprwm/hyprland-plugins/tree/v0.51.0/hyprscrolling
            plugin.hyprscrolling = {
              fullscreen_on_one_column = box.isLaptop or false;
              focus_fit_method = 0;
            };

            bind = [
              "SUPER      , period, layoutmsg, move +col"
              "SUPER      , comma,  layoutmsg, move -col"
              "SUPER SHIFT, period, layoutmsg, movewindowto r"
              "SUPER SHIFT, comma,  layoutmsg, movewindowto l"
              "SUPER SHIFT, K,      layoutmsg, movewindowto u"
              "SUPER SHIFT, J,      layoutmsg, movewindowto d"
              # "SUPER,       Return,       layoutmsg, swapwithmaster master"
              # "SUPER,       M,            layoutmsg, focusmaster auto"
              # "SUPER SHIFT, backslash,    layoutmsg, orientationcycle left right"
              # "SUPER,       space,        layoutmsg, orientationnext"
              # "SUPER SHIFT, space,        layoutmsg, focusmaster master"
              # "SUPER SHIFT, space,        layoutmsg, mfact exact 0.66"
              # "SUPER SHIFT, space,        layoutmsg, orientationright"
              # "SUPER,       bracketright, layoutmsg, rollnext"
              # "SUPER,       bracketleft,  layoutmsg, rollprev"
              # "SUPER,       period,       layoutmsg, addmaster"
              # "SUPER,       comma,        layoutmsg, removemaster"
              # "SUPER SHIFT, J,            layoutmsg, swapnext"
              # "SUPER SHIFT, K,            layoutmsg, swapprev"
              # "SUPER,       J,            layoutmsg, cyclenext"
              # "SUPER,       Tab,          layoutmsg, cyclenext"
              # "SUPER,       K,            layoutmsg, cycleprev"
              # "SUPER SHIFT, Tab,          layoutmsg, cycleprev"
              # "SUPER,       H,            layoutmsg, mfact +0.05"
              # "SUPER SHIFT, H,            layoutmsg, mfact +0.2"
              # "SUPER,       L,            layoutmsg, mfact -0.05"
              # "SUPER SHIFT, L,            layoutmsg, mfact -0.2"
            ];
          };
        };
      };
    };
}
