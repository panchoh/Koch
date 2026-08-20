{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.console;
    in
    {
      options.traits.console = {
        enable = lib.mkEnableOption "console" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {

        services.xserver.xkb = {
          model = "pc104";
          layout = "us,us";
          variant = "altgr-intl,colemak_dh";
          options = "lv3:ralt_switch_multikey,grp:rctrl_toggle,nbsp:level3n";
        };

        console = {
          packages = [ pkgs.powerline-fonts ];
          useXkbConfig = true;
        };
      };
    };
}
