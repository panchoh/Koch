{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        services.greetd = {
          enable = true;
          restart = true;
          settings.default_session = {
            command = "${lib.getExe config.programs.hyprland.package} &>~/.Wsession.errors";
            user = box.userName or "alice";
          };
        };
      };
    };
}
