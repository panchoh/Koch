{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.bottom = {
          enable = lib.mkEnableOption "bottom" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.bottom;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.bottom = {

            enable = true;

            # https://github.com/ClementTsang/bottom
            settings = {

              colors = {
                low_battery_color = "red";
              };

              flags = {
                battery = true;
                no_write = true;
                read_only = true;
                temperature_type = "celsius";
              };
            };
          };
        };
      };
  };
}
