{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.helix = {
          enable = lib.mkEnableOption "Helix" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.helix;
      in
      {
        config = lib.mkIf cfg.enable {

          programs.helix = {

            enable = true;

            settings = {

              editor.cursor-shape = {
                normal = "block";
                insert = "bar";
                select = "underline";
              };
            };

            languages.language = [

              {
                name = "nix";
                auto-format = true;
                formatter.command = lib.getExe pkgs.nixfmt;
              }

              {
                name = "go";
                auto-format = true;
                formatter.command = lib.getExe pkgs.gofumpt;
              }
            ];

            settings = {

              editor = {
                line-number = "relative";
                lsp.display-messages = true;
              };
            };
          };
        };
      };
  };
}
