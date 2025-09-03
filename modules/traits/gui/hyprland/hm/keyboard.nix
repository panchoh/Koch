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
      pkgs.libinput # for libinput list-devices
      pkgs.libxkbcommon # for xkbcli interactive-wayland
      pkgs.xkeyboard_config
      pkgs.wev # for wev -f wl_keyboard
      pkgs.wlrctl # for wlrctl keyboard <action>
      pkgs.wtype
    ];

    wayland.windowManager.hyprland.settings = {
      misc.key_press_enables_dpms = true;

      device =
        let
          defaults = {
            name = "unnamed-keyboard";
            kb_model = "pc104";
            kb_layout = "us,us";
            kb_variant = "altgr-intl,colemak_dh";
            kb_options = "lv3:ralt_switch_multikey,grp:rctrl_toggle,nbsp:level3n";
            # kb_options explanation:
            # AltGr: 3rd. level
            # AltGr-Shift: 4th. level
            # AltGr-Space: non-breaking space
            # AltGr-Shift-Space: thin non-breaking space
            # Shift-AltGr: compose
            # Caps: Ye'Olde Caps
            # Right Control: group switch
          };
        in
        [
          {
            name = "apple-inc.-apple-internal-keyboard-/-trackpad-1";
            kb_model = "applealu_ansi";
          }
          {
            name = "at-translated-set-2-keyboard-1";
            kb_model = "thinkpad";
          }
          {
            name = "PFU_Limited_HHKB-Classic";
            kb_model = "hhk";
          }
          { name = "keychron-keychron-q8"; }
          { name = "keychron-keychron-q10"; }
          { name = "logitech-k400-plus-2"; }
          { name = "logitech-usb-receiver-2"; }
        ]
        |> map (overrides: defaults // overrides);
    };
  };
}
