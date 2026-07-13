{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.yazi;
    in
    {
      options.traits.hm.yazi = {
        enable = lib.mkEnableOption "yazi" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.yazi = {
          enable = true;
          enableFishIntegration = true;
        };
      };
    };
}
