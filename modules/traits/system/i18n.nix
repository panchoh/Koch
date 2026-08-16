{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.traits.i18n;
    in
    {
      options.traits.i18n = {
        enable = lib.mkEnableOption "i18n" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {

        i18n.extraLocaleSettings = {

          # m, not in
          LC_MEASUREMENT = "en_DK.UTF-8";

          # €, not $
          LC_MONETARY = "en_IE.UTF-8";

          # DIN A4, not legal
          LC_PAPER = "en_DK.UTF-8";

          # yes, that means ISO-8601 ;-)
          LC_TIME = "en_DK.UTF-8";
        };
      };
    };
}
