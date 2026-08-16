{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      # pkgs,
      ...
    }:

    let
      cfg = nixosConfig.traits.hyprland;
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
