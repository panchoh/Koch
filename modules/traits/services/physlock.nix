{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.physlock;
    in
    {
      options.traits.physlock = {
        enable = lib.mkEnableOption "physlock" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        services.physlock.enable = true;
      };
    };
}
