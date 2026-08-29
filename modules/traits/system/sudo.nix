{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.traits.sudo;
    in
    {
      options.traits.sudo = {
        enable = lib.mkEnableOption "sudo" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {

        security.sudo = {
          enable = !config.security.run0.enable;
          execWheelOnly = true;
        };

        nixpkgs.config.packageOverrides = pkgs: {
          sudo = pkgs.sudo.override { withInsults = true; };
        };
      };
    };
}
