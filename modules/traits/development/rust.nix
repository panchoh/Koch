{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.rust;
    in
    {
      options.traits.hm.rust = {
        enable = lib.mkEnableOption "Rust" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.cargo
          pkgs.rustc
          pkgs.rust-analyzer
        ];
      };
    };
}
