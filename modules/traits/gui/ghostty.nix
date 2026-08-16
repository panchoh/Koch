{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.ghostty = {
          enable = lib.mkEnableOption "Ghostty" // {
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
        cfg = nixosConfig.traits.ghostty;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.ghostty = {

            enable = true;
            enableFishIntegration = true;
            installBatSyntax = true;

            settings = {
              window-decoration = false;
              cursor-style = "block";
              cursor-style-blink = false;
              bell-features = "attention, title, border";
              shell-integration-features = "no-cursor";
            };
          };
        };
      };
  };

}
