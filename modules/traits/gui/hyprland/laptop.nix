{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland.settings.workspace_rule = [
          {
            workspace = "name:coding";
            monitor = "eDP-1";
            default = !(box.hasWideDisplay or true);
            layout = "monocle";
            persistent = (box.isLaptop or false) && !(box.hasWideDisplay or true);
            gaps_in = 0;
            gaps_out = 0;
            no_border = true;
            no_rounding = true;
            decorate = false;
            on_created_empty = ''
              hyprctl monitors -j | jq --raw-output --exit-status 'any(.[]; .name | test("^eDP-[0-9]$"))' > /dev/null && doom-emacs
            '';
          }
        ];
      };
    };
}
