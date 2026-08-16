{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.editorconfig = {
          enable = lib.mkEnableOption "EditorConfig" // {
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
        cfg = nixosConfig.traits.editorconfig;
      in
      {
        config = lib.mkIf cfg.enable {

          editorconfig = {

            enable = true;

            # REVIEW: these are global
            # settings = {
            #   "*" = {
            #     indent_style = "tab";
            #     indent_size = 4;
            #   };
            # };
          };
        };
      };
  };
}
