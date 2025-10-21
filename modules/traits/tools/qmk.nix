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
        cfg = config.traits.os.qmk;
      in
      {
        options.traits.os.qmk = {
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
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.qmk;
      in
      {
        options.traits.hm.qmk = {
          enable = lib.mkEnableOption "QMK" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.qmk
            pkgs.qmk_hid
            pkgs.keymapviz
            pkgs.clang-tools
            pkgs.dfu-programmer
            pkgs.dfu-util
          ];
        };
      };
  };
}
