{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.abook;
    in
    {
      options.traits.hm.abook = {
        enable = lib.mkEnableOption "Abook" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.abook.enable = true;
      };
    };
}
