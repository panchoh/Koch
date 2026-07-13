{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.jq;
    in
    {
      options.traits.hm.jq = {
        enable = lib.mkEnableOption "jq" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.jq.enable = true;
      };
    };
}
