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
              focus_fit_method = 1;
              follow_focus = false;
              fullscreen_on_one_column = box.isLaptop or false;
              column_width = if !box.isLaptop or false then 0.333 else 0.5;
              explicit_column_widths = "0.333, 0.5, 0.667, 0.8, 1.0";
            };

            bind = [
              "SUPER      , comma  , layoutmsg, move -col"
              "SUPER      , period , layoutmsg, move +col"

              "SUPER      , H      , layoutmsg, focus l"
              "SUPER      , Tab    , layoutmsg, focus l"
              "SUPER      , K      , layoutmsg, focus u"
              "SUPER      , J      , layoutmsg, focus d"
              "SUPER      , L      , layoutmsg, focus r"
              "SUPER SHIFT, Tab    , layoutmsg, focus r"

              "SUPER SHIFT, comma  , layoutmsg, movewindowto l"
              "SUPER SHIFT, K      , layoutmsg, movewindowto u"
              "SUPER SHIFT, J      , layoutmsg, movewindowto d"
              "SUPER SHIFT, period , layoutmsg, movewindowto r"

              "SUPER      , space  , layoutmsg, colresize +conf"
              "SUPER SHIFT, space  , layoutmsg, colresize -conf"
              "SUPER ALT  , space  , layoutmsg, colresize all 0.333"

              "SUPER      , Return , layoutmsg, promote"

              # Move active column to a workspace with SUPER + ALT + [0-9]
              "SUPER ALT  , 1      , layoutmsg, movecoltoworkspace  1"
              "SUPER ALT  , 2      , layoutmsg, movecoltoworkspace  2"
              "SUPER ALT  , 3      , layoutmsg, movecoltoworkspace  3"
              "SUPER ALT  , 4      , layoutmsg, movecoltoworkspace  4"
              "SUPER ALT  , 5      , layoutmsg, movecoltoworkspace  5"
              "SUPER ALT  , 6      , layoutmsg, movecoltoworkspace  6"
              "SUPER ALT  , 7      , layoutmsg, movecoltoworkspace  7"
              "SUPER ALT  , 8      , layoutmsg, movecoltoworkspace  8"
              "SUPER ALT  , 9      , layoutmsg, movecoltoworkspace  9"
              "SUPER ALT  , 0      , layoutmsg, movecoltoworkspace 10"

              "SUPER ALT  , H      , layoutmsg, movecoltoworkspace -1"
              "SUPER ALT  , L      , layoutmsg, movecoltoworkspace +1"

              "SUPER ALT  , grave  , layoutmsg, movecoltoworkspace special:Foot"
              "SUPER ALT  , Minus  , layoutmsg, movecoltoworkspace special:Telegram"
              "SUPER ALT  , Equal  , layoutmsg, movecoltoworkspace special:Transmission"

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
