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
      general.layout = "master";
      master = {
        mfact = 0.66;
        new_status = "inherit";
        new_on_active = "before";
        new_on_top = true;
        drop_at_cursor = false;
        smart_resizing = false;
        orientation = "right";
        slave_count_for_center_master = 0;
      };
      bind = [
        "SUPER,       Return,       layoutmsg, swapwithmaster master"
        "SUPER,       M,            layoutmsg, focusmaster auto"
        "SUPER SHIFT, backslash,    layoutmsg, orientationcycle left right"
        "SUPER,       space,        layoutmsg, orientationnext"
        "SUPER SHIFT, space,        layoutmsg, focusmaster master"
        "SUPER SHIFT, space,        layoutmsg, mfact exact 0.66"
        "SUPER SHIFT, space,        layoutmsg, orientationright"
        "SUPER,       bracketright, layoutmsg, rollnext"
        "SUPER,       bracketleft,  layoutmsg, rollprev"
        "SUPER,       period,       layoutmsg, addmaster"
        "SUPER,       comma,        layoutmsg, removemaster"
        "SUPER SHIFT, J,            layoutmsg, swapnext"
        "SUPER SHIFT, K,            layoutmsg, swapprev"
        "SUPER,       J,            layoutmsg, cyclenext"
        "SUPER,       Tab,          layoutmsg, cyclenext"
        "SUPER,       K,            layoutmsg, cycleprev"
        "SUPER SHIFT, Tab,          layoutmsg, cycleprev"
        "SUPER,       H,            layoutmsg, mfact +0.05"
        "SUPER SHIFT, H,            layoutmsg, mfact +0.2"
        "SUPER,       L,            layoutmsg, mfact -0.05"
        "SUPER SHIFT, L,            layoutmsg, mfact -0.2"
      ];
    };
  };
}
