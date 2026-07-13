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
        programs.starship = {
          enable = true;
          enableTransience = true;
          presets = [ "nerd-font-symbols" ];
          settings = {
            hostname.ssh_only = false;
            fossil_branch.symbol = " ";
            git_branch.symbol = " ";
            hg_branch.symbol = " ";
          };
        };
      };
    };
}
