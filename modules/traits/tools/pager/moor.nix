{
  flake = {

    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.moor = {
          enable = lib.mkEnableOption "moor" // {
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
        cfg = nixosConfig.traits.moor;
      in
      {
        config = lib.mkIf cfg.enable {

          programs = {

            fish.shellAbbrs.p = "moor";

            moor = {
              enable = true;
              options = {
                no-linenumbers = true;
                no-statusbar = true;
                reformat = true;
                style = "dracula";
              };
            };
          };
        };
      };
  };
}
