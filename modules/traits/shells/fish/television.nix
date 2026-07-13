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
}
