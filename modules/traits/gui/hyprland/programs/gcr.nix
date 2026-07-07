{
  flake.nixosModules.default =
    {
      config,
      pkgs,
      ...
    }:
    {
      services.dbus.packages = [ pkgs.gcr ]; # for pinentry-gnome3
    };

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
        services.gpg-agent.pinentry.package = lib.mkDefault pkgs.pinentry-gnome3;
        wayland.windowManager.hyprland.settings.window_rule = [
          {
            match.class = "^gcr-prompter$";
            no_anim = true;
            xray = true;
            dim_around = true;
            stay_focused = true;
          }
        ];
      };
    };
}
