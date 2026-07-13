{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.fish;
    in
    {
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
