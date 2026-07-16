{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.openvi;
    in
    {
      options.traits.hm.ed = {
        enable = lib.mkEnableOption "GNU ed" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        # https://en.wikipedia.org/wiki/Ed_(text_editor)
        # https://www.gnu.org/software/ed/
        # https://www.gnu.org/software/ed/manual/ed_manual.html
        home.packages = [ pkgs.ed ];
      };
    };
}
