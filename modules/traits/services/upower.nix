{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.upower;
    in
    {
      options.traits.upower = {
        enable = lib.mkEnableOption "UPower" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        services.upower = {
          enable = true;
          criticalPowerAction = "PowerOff";
        };
      };
    };
}
