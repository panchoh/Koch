{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.television = {
          enable = lib.mkEnableOption "television" // {
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
        cfg = nixosConfig.traits.television;
      in
      {
        config = lib.mkIf cfg.enable {

          programs = {

            television = {

              enable = true;

              settings = {

                default_channel = "nix-search-tv";

                ui = {

                  status_bar = {
                    separator_open = "";
                    separator_close = "";
                  };

                  theme = "dracula";
                };
              };
            };

            nix-search-tv = {
              enable = true;
              settings.experimental.render_docs_indexes.nvf = "https://notashelf.github.io/nvf/options.html";
            };
          };
        };
      };
  };
}
