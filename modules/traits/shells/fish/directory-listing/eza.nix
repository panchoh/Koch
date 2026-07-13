{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.fish;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.eza = {
          enable = true;
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
