{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.atuin = {
          enable = lib.mkEnableOption "atuin" // {
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
        cfg = nixosConfig.traits.atuin;
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
  };
}
