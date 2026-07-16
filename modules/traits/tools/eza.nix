{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.eza;
    in
    {
      options.traits.hm.eza = {
        enable = lib.mkEnableOption "eza" // {
          default = box.isStation or false;
        };
      };

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
}
