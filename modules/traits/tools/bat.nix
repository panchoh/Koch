{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.bat;
    in
    {
      options.traits.hm.bat = {
        enable = lib.mkEnableOption "bat" // {
          default = box.isStation or false;
        };
      };

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
