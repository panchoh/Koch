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
