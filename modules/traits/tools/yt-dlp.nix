{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.yt-dlp = {
          enable = lib.mkEnableOption "yt-dlp" // {
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
        cfg = nixosConfig.traits.yt-dlp;
      in
      {
        config = lib.mkIf cfg.enable {

          programs = {

            aria2.enable = true;

            yt-dlp = {

              enable = true;

              settings = {
                embed-metadata = true;
                embed-thumbnail = true;
                embed-subs = true;
                sub-langs = "all";
                downloader = "aria2c";
                downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
              };
            };
          };
        };
      };
  };
}
