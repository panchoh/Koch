{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.qmk;
      in
      {
        options.traits.qmk = {
          enable = lib.mkEnableOption "QMK" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          hardware.keyboard.qmk.enable = true;
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.qmk;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.qmk
            pkgs.qmk_hid
            pkgs.dos2unix # used by qmk setup
            pkgs.keymapviz
            pkgs.clang-tools
            pkgs.dfu-programmer
            pkgs.dfu-util
          ];
        };
      };
  };
}
