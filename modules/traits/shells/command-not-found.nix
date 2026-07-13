{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.command-not-found;
    in
    {
      options.traits.os.command-not-found = {
        enable = lib.mkEnableOption "command-not-found" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.command-not-found.enable = false;
      };
    };
}
