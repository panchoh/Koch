{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.eza = {
          enable = lib.mkEnableOption "eza" // {
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
        cfg = nixosConfig.traits.eza;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.eza = {

            enable = true;
            enableBashIntegration = false;
            enableFishIntegration = false;
            enableIonIntegration = false;
            git = true;
            icons = "auto";

            extraOptions = [
              "--binary"
              # "--context"
              "--git-repos-no-status"
              "--group-directories-first"
              "--group"
              "--extended"
              "--header"
              # "--inode"
              "--links"
              "--mounts"
              "--time-style=relative"
            ];
          };
        };
      };
  };
}
