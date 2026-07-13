{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.fish;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.bat = {
          enable = true;
          config = {
            italic-text = "always";
            # https://github.com/sharkdp/bat/issues/376
            # pager = "less --+status-column";
            terminal-width = "-2";
            paging = "always";
            style = "full";
          };
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batman
            batgrep
            batwatch
          ];
        };
      };
    };
}
