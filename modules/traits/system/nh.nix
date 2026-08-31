{
  flake = {

    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.nh = {
          enable = lib.mkEnableOption "NH" // {
            default = true;
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.nh;
      in
      {
        config = lib.mkIf cfg.enable {

          home = {

            packages = [
              pkgs.dix
              pkgs.nix-output-monitor
            ];

            sessionVariables.NH_SHOW_ACTIVATION_LOGS = true;
          };

          programs.nh = {

            enable = nixosConfig.nix.enable && !nixosConfig.system.disableInstallerTools;

            clean = {
              enable = true;
              dates = "daily";
              extraArgs = "--keep 5 --keep-since 3d";
            };

            flake = "${config.xdg.userDirs.projects}/${box.githubUser}/${box.flakeRepoName}";
          };
        };
      };
  };
}
