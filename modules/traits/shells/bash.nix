{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.bash = {
          enable = lib.mkEnableOption "Bash" // {
            default = true;
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
        cfg = nixosConfig.traits.bash;
      in
      {
        config = lib.mkIf cfg.enable {

          programs = {

            bash.enable = true;

            readline = {
              enable = true;
              variables.bell-style = "visible";
            };
          };
        };
      };
  };
}
