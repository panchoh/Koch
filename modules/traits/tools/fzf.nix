{
  flake.homeModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.fzf;
    in
    {
      options.traits.hm.fzf = {
        enable = lib.mkEnableOption "fzf" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        programs.fzf = {
          enable = true;
          enableBashIntegration = !config.programs.television.enable;
          enableFishIntegration = !config.programs.television.enable;
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
