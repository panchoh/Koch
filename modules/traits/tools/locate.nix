{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.locate;
    in
    {
      options.traits.locate = {
        enable = lib.mkEnableOption "locate" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        services.locate = {
          enable = true;
          package = pkgs.plocate;
        };
      };
    };
}
