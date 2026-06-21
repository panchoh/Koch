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
          settings = {
            config = {
              # https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
              general.layout = "scrolling";
              scrolling = {
                focus_fit_method = 1;
                follow_focus = false;
                fullscreen_on_one_column = !box.hasWideDisplay or false;
                column_width = if !box.hasWideDisplay or false then 0.5 else 0.333;
                explicit_column_widths = "0.333, 0.5, 0.667, 0.8, 1.0";
              };
            };
            bind =
              lib.mapAttrsToList
                (keys: msg: {
                  _args = [
                    keys
                    (lib.generators.mkLuaInline ''hl.dsp.layout("${msg}")'')
                  ];
                })
                {
                  "SUPER + H" = "focus l";
                  "SUPER + K" = "focus u";
                  "SUPER + J" = "focus d";
                  "SUPER + L" = "focus r";

                  "SUPER + space" = "colresize +conf";
                  "SUPER + SHIFT + space" = "colresize -conf";
                  "SUPER + ALT + space" = "colresize all 0.333";
                  "SUPER + CONTROL + space" = "inhibit_scroll";

                  "SUPER + SHIFT + Return" = "promote";
                  "SUPER + comma" = "move -col";
                  "SUPER + period" = "move +col";
                  "SUPER + SHIFT + comma" = "swapcol l";
                  "SUPER + SHIFT + period" = "swapcol r";
                  "SUPER + ALT + comma" = "consume";
                  "SUPER + ALT + period" = "expel";
                  "SUPER + CONTROL + comma" = "consume_or_expel prev";
                  "SUPER + CONTROL + period" = "consume_or_expel next";
                }
              ++
                lib.mapAttrsToList
                  (keys: dir: {
                    _args = [
                      keys
                      (lib.generators.mkLuaInline ''hl.dsp.window.move({ direction = "${dir}" })'')
                    ];
                  })
                  {
                    "SUPER + SHIFT + H" = "l";
                    "SUPER + SHIFT + K" = "u";
                    "SUPER + SHIFT + J" = "d";
                    "SUPER + SHIFT + L" = "r";
                  };
          };
        };
      };
    };
}

# REVIEW: Remnants from Master layout.  Some might apply here.
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
