{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.bottom;
    in
    {
      options.traits.hm.bottom = {
        enable = lib.mkEnableOption "bottom" // {
          default = box.isStation or false;
        };
      };

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
}
