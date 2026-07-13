{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:
      {
        options.traits.os.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        lib,
        box ? null,
        ...
      }:
      {
        options.traits.hm.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };
      };
  };
}
