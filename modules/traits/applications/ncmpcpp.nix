{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.ncmpcpp;
    in
    {
      options.traits.hm.ncmpcpp = {
        enable = lib.mkEnableOption "NCurses Music Player Client (Plus Plus)" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.ncmpcpp = {
          enable = true;
          bindings = [
            {
              key = "j";
              command = "scroll_down";
            }
            {
              key = "k";
              command = "scroll_up";
            }
          ];
        };
      };
    };
}
