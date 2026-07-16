{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.lsd;
    in
    {
      options.traits.hm.lsd = {
        enable = lib.mkEnableOption "lsd" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.lsd = {
          enable = true;
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
