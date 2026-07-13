{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      nixosConfig,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.man;
    in
    {
      options.traits.hm.mangl = {
        enable = lib.mkEnableOption "mangl" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = lib.optionals nixosConfig.documentation.man.man-db.enable [
          # BUG: mangl is based on mandoc lib, but misses env: ‘manpath’
          pkgs.mangl # https://github.com/zigalenarcic/mangl
        ];

        # TODO: generate ~/.manglrc
      };
    };
}
