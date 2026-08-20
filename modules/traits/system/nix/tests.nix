{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.traits.nix;
    in
    {
      config = lib.mkIf cfg.enable {

        # https://nixos.org/manual/nixos/unstable/#sec-running-nixos-tests
        nix.settings = {

          auto-allocate-uids = true;

          experimental-features = [
            "auto-allocate-uids"
            "cgroups"
          ];

          system-features = [ "uid-range" ];
          sandbox-paths = [ "/dev/net" ];
        };
      };
    };
}
