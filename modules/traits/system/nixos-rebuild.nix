{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.traits.nixos-rebuild;
    in
    {
      options.traits.nixos-rebuild = {
        enable = lib.mkEnableOption "nixos-rebuild" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        # REVIEW:
        # system.tools.nixos-rebuild.enable =
        #   config.nix.enable && !config.traits.nh.enable && !config.system.disableInstallerTools;
      };
    };
}
