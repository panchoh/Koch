{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        home.packages = [
          # https://mstoeckl.com/notes/gsoc/blog.html
          # REVIEW: https://nixpk.gs/pr-tracker.html?pr=552268
          # pkgs.waypipe
        ];
      };
    };
}
