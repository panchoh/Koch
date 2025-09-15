{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.walker;
in
{
  options.traits.hm.walker = {
    enable = lib.mkEnableOption "Walker" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    services.walker = {
      enable = true;
      systemd.enable = true;
      settings = {
        app_launch_prefix = "";
        as_window = false;
        close_when_open = false;
        disable_click_to_close = false;
        force_keyboard_focus = true;
        hotreload_theme = false;
        locale = "";
        monitor = "";
        terminal_title_flag = "";
        theme = "default";
        timeout = 0;
      };
    };
  };
}
