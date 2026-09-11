{
  flake = {

    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.bat = {
          enable = lib.mkEnableOption "bat" // {
            default = box.isStation or false;
          };
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
        cfg = nixosConfig.traits.bat;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.bat = {

            enable = true;

            config = {

              italic-text = "always";
              paging = "always";
              style = "full";
            }
            // lib.optionalAttrs nixosConfig.traits.moor.enable {
              pager = "moor --quit-if-one-screen";
            }
            // lib.optionalAttrs (!nixosConfig.traits.moor.enable) {

              # https://github.com/sharkdp/bat/issues/376
              # pager = "less --+status-column";
              terminal-width = "-2";
            };

            extraPackages = with pkgs.bat-extras; [
              batdiff
              batman
              batgrep
              batwatch
            ];
          };
        };
      };
  };
}
