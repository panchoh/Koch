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
        home.packages = [
          pkgs.tig
        ];

        xdg.configFile."tig/config".text = ''
          set line-graphics = auto
          color cursor      black green bold
          color cursor-blur green black dim
        '';

        programs = {
          # Otherwise mouse wheel will wreak havoc
          foot.settings.mouse.alternate-scroll-mode = false;

          fish.shellAbbrs = {
            t = "tig";
            tf = "tig FETCH_HEAD"; # for ad-hoc fetches, say git fetch upstream pull/<pr_id>/head

            # https://git-scm.com/docs/gitrevisions#Documentation/gitrevisions.txt-branchnameupstreamegmasterupstreamu
            tu = "tig @{upstream}"; # or tig @{u}
          };
        };
      };
    };
}
