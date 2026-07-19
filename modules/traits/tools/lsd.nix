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
        programs = {
          fish.shellAbbrs = {
            l = "lsd --long --almost-all";
            ls = "lsd";
            lso = "lsd --oneline";
            ll = "lsd --long";
            la = "lsd --almost-all";
            lao = "lsd --almost-all --one-line";
            lt = "lsd --tree";
            lla = "lsd --long --almost-all";
            llt = "lsd --long --tree";
            llat = "lsd --long --almost-all --tree";
          };

          lsd = {
            enable = true;
            enableBashIntegration = false;
            enableFishIntegration = false;
            enableZshIntegration = false;
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
    };
}
