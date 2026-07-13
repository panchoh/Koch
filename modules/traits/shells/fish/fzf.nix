{
  flake.homeModules.default =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.traits.hm.fish;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.fzf = {
          enable = false;
          defaultCommand = "fd --type f";
          defaultOptions = [
            "--height 40%"
            "--border"
          ];
          fileWidget.command = "fd --type f";
          fileWidget.options = [
            "--preview 'head {}'"
          ];
          tmux = {
            enableShellIntegration = true;
            shellIntegrationOptions = [ "-d 40%" ];
          };
        };
      };
    };
}
