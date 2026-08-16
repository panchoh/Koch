{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.openvi = {
          enable = lib.mkEnableOption "OpenVi" // {
            default = true;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.openvi;
      in
      {
        config = lib.mkIf cfg.enable {

          home = {

            packages = [ pkgs.openvi ];

            activation = {

              addOviDotExrc = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                verboseEcho Setting up .exrc
                run echo set verbose showmode number tabstop=2 shiftwidth=2 expandtab > $HOME/.exrc
              '';
            };
          };
        };
      };
  };
}
