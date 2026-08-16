{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.fzf = {
          enable = lib.mkEnableOption "fzf" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.fzf;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.fzf = {

            enable = true;
            enableBashIntegration = !nixosConfig.traits.television.enable;
            enableFishIntegration = !nixosConfig.traits.television.enable;
            defaultCommand = "fd --type f";

            defaultOptions = [
              "--height 40%"
              "--border"
            ];

            fileWidget.command = "fd --type f";

            fileWidget.options = [
              "--preview 'head {}'"
            ];

            historyWidget.command = lib.optionalString (!nixosConfig.traits.television.enable) "";

            tmux = {
              enableShellIntegration = true;
              shellIntegrationOptions = [ "-d 40%" ];
            };

          };
        };
      };
  };
}
