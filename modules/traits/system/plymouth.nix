{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.plymouth;
    in
    {
      options.traits.plymouth = {
        enable = lib.mkEnableOption "Plymouth" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        boot.plymouth.enable = true;
        stylix.targets.plymouth.enable = false;
      };
    };
}
