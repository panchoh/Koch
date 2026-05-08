{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.editorconfig;
    in
    {
      options.traits.hm.editorconfig = {
        enable = lib.mkEnableOption "EditorConfig" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        editorconfig = {
          enable = true;
          settings = {
            "*" = {
              indent_style = "tab";
              indent_size = 4;
            };
          };
        };
      };
    };
}
