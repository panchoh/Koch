{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.vscode;
      in
      {
        options.traits.vscode = {
          enable = lib.mkEnableOption "Visual Studio Code" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          nixpkgs.config.allowUnfreePackages = [ "vscode" ];
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.vscode;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.vscode.enable = true;
        };
      };
  };
}
