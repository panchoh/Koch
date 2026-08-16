{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.btop = {
          enable = lib.mkEnableOption "btop" // {
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
        cfg = nixosConfig.traits.btop;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.btop = {
            enable = true;
            settings.vim_keys = true; # https://github.com/aristocratos/btop#configurability
          };
        };
      };
  };
}
