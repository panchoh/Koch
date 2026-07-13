{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.tealdeer;
    in
    {
      options.traits.hm.tealdeer = {
        enable = lib.mkEnableOption "tealdeer" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.tealdeer = {
          enable = true;
          settings.updates.auto_update = true;
        };
      };
    };
}
