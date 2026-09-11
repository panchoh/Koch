{
  inputs,
  ...
}:

{
  flake = {

    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.nix-index-database = {
          enable = lib.mkEnableOption "nix-index-database" // {
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
        cfg = nixosConfig.traits.nix-index-database;
      in
      {
        imports = [ inputs.nix-index-database.homeModules.default ];

        config = lib.mkIf cfg.enable {
          programs.nix-index-database.comma.enable = true;
        };
      };
  };
}
