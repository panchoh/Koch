{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.git;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.gh = {
          enable = true;
          settings.git_protocol = "ssh";
          extensions = [
            pkgs.gh-eco
            pkgs.gh-dash
            pkgs.gh-enhance
          ];
        };
      };
    };
}
