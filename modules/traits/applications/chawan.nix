{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.chawan = {
          enable = lib.mkEnableOption "Chawan" // {
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
        cfg = nixosConfig.traits.chawan;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.chawan = {
            enable = true;

            settings = {

              # https://git.sr.ht/~bptato/chawan/tree/HEAD/doc/config.md
              buffer = {
                images = true;
                autofocus = true;
              };

              pager."C-k" = "() => pager.load('https://duckduckgo.com/?=')";
            };
          };
        };
      };
  };
}
