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
      pkgs.wayland-utils # for wayland-info
      pkgs.vrrtest
    ];
    wayland.windowManager.hyprland.settings = {
      # https://wiki.hypr.land/Configuring/Monitors/#monitor-v2
      monitorv2 = [
        {
          output = "desc:Chimei Innolux Corporation 0x14D4";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
        {
          output = "desc:Dell Inc. DELL U4025QW B1MKH34";
          mode = "highrr";
          position = "auto";
          scale = "auto";
          bitdepth = 10;
        }
        {
          output = "desc:Dell Inc. DELL U3818DW 5KC0386E05KL";
          mode = "preferred";
          position = "auto";
          scale = "auto";
          bitdepth = 10;
        }
        {
          output = "desc:XXX Beyond TV 0x00010000";
          mode = "preferred";
          position = "auto";
          scale = 1.5;
          bitdepth = 10;
        }
      ];
    };
  };
}
