{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.lf;
    in
    {
      options.traits.hm.lf = {
        enable = lib.mkEnableOption "lf" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.lf = {
          enable = true;
          settings = {
            icons = true;
            sixel = true;
          };
        };
      };
    };
}
