{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.git;
    in
    {
      config = lib.mkIf cfg.enable {
        programs = {
          difftastic = {
            enable = true;
            git = {
              enable = true;
              mode = "both";
            };
            options = {
              color = "always";
              display = "side-by-side-show-both";
              sort-paths = true;
              tab-width = 8;
            };
          };

          git.settings.alias = {
            ddiff = "diff --no-ext-diff";
            dlog = "log --ext-diff";
            dshow = "show --ext-diff";
          };
        };
      };
    };
}
