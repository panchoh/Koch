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
        box ? null,
        ...
      }:
      let
        cfg = nixosConfig.traits.bat;
      in
      {
        options.traits.bat = {
          enable = lib.mkEnableOption "bat" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {

          programs.bat = {

            enable = true;

            config = {
              italic-text = "always";
              # https://github.com/sharkdp/bat/issues/376
              # pager = "less --+status-column";
              terminal-width = "-2";
              paging = "always";
              style = "full";
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
