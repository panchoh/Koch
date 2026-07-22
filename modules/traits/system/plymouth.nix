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
      cfg = config.traits.os.plymouth;
    in
    {
      options.traits.os.plymouth = {
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
