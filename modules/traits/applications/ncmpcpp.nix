{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.ncmpcpp = {
          enable = lib.mkEnableOption "NCurses Music Player Client (Plus Plus)" // {
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
        cfg = nixosConfig.traits.ncmpcpp;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.ncmpcpp = {
            enable = true;

            bindings = [
              {
                key = "h";
                command = "jump_to_parent_directory";
              }

              {
                key = "j";
                command = "scroll_down";
              }

              {
                key = "k";
                command = "scroll_up";
              }

              {
                key = "l";
                command = "enter_directory";
              }
            ];
          };
        };
      };
  };
}
