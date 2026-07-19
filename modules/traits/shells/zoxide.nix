{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.zoxide;
    in
    {
      options.traits.hm.zoxide = {
        enable = lib.mkEnableOption "zoxide" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        home.sessionVariables = {
          _ZO_ECHO = "1";
          _ZO_RESOLVE_SYMLINKS = "1";
        };

        programs.zoxide.enable = true;
      };
    };
}
