{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.starship;
    in
    {
      options.traits.hm.starship = {
        enable = lib.mkEnableOption "starship" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.starship = {
          enable = true;
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
