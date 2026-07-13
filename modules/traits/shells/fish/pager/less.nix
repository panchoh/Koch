{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.traits.os.fish;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.less.enable = lib.mkForce false;
        };
      };

    homeModules.default =
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
          programs.less = {
            enable = true;
            options = lib.mkMerge [
              {
                clear-screen = true;
                form-feed = true;
                incsearch = true;
                Long-Prompt = true;
                mouse = true;
                no-histdups = true;
                Raw-Control-Chars = true;
                # Uncomment to keep the output of less upon quit
                # redraw-on-quit = true;
                save-marks = true;
                status-column = true;
                status-line = false;
                use-color = true;
                wheel-lines = 3;
              }
              # Ordering issue fixed on https://github.com/nix-community/home-manager/pull/8204
              (lib.mkAfter {
                color = [
                  "Pkmsd"
                  "Mkmsd"
                ];
              })
            ];
          };
        };
      };
  };
}
