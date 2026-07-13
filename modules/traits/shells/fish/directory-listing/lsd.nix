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
        programs.lsd = {
          enable = !config.programs.eza.enable;
          settings = {
            date = "relative";
            header = true;
            icons = {
              when = "auto";
              separator = "  ";
              theme = "fancy";
            };
            indicators = true;
            sorting.dir-grouping = "first";
            literal = true;
            total-size = false;
            blocks = [
              "permission"
              "links"
              # "inode"
              "user"
              "group"
              # "context"
              "size"
              "date"
              "git"
              "name"
            ];
          };
        };
      };
    };
}
