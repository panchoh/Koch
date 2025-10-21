{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.os.sudo;
    in
    {
      options.traits.os.sudo = {
        enable = lib.mkEnableOption "sudo" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        nixpkgs.config.packageOverrides = pkgs: {
          sudo = pkgs.sudo.override { withInsults = true; };
        };
      };
    };
}
