{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.atuin;
    in
    {
      options.traits.hm.atuin = {
        enable = lib.mkEnableOption "atuin" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.atuin = {
          enable = true;
          flags = [ "--disable-up-arrow" ];
          settings = {
            auto_sync = false;
            common_prefix = [ "run0" ];
            dotfiles.enabled = false;
            enter_accept = true;
            exit_mode = "return-query";
            sync.records = true;
            workspaces = true;
          };
        };
      };
    };
}
