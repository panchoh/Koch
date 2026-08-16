{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.imv = {
          enable = lib.mkEnableOption "imv" // {
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
        cfg = nixosConfig.traits.imv;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.imv = {

            enable = true;

            settings.binds."<Shift+Delete>" = ''
              exec rm "$imv_current_file"; close
            '';
          };
        };
      };
  };

}
