{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.starship = {
          enable = lib.mkEnableOption "starship" // {
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
        cfg = nixosConfig.traits.starship;
      in
      {
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
  };
}
