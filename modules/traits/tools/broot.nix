{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.broot;
    in
    {
      options.traits.hm.broot = {
        enable = lib.mkEnableOption "broot" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        # https://dystroy.org/broot/
        programs.broot = {
          enable = true;
          settings = {
            modal = true;
            # TODO: explore the tool and configure verbs et al.
            # verbs = [ { } ];
          };
        };
      };
    };
}
