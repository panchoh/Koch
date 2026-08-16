{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.zoxide = {
          enable = lib.mkEnableOption "zoxide" // {
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
        cfg = nixosConfig.traits.zoxide;
      in
      {
        config = lib.mkIf cfg.enable {

          home.sessionVariables = {
            _ZO_ECHO = "1";
            _ZO_RESOLVE_SYMLINKS = "1";
          };

          programs.zoxide.enable = true;
        };
      };
  };
}
