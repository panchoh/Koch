{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.ollama;
    in
    {
      options.traits.ollama = {
        enable = lib.mkEnableOption "Ollama" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        services.ollama = {
          enable = true;
        };
      };
    };
}
