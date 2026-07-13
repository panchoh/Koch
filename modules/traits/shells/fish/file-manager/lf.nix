{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.fish;
    in
    {
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
