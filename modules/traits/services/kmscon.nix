{
  flake.nixosModules.default =
    {
      config,
      lib,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.kmscon;
    in
    {
      options.traits.os.kmscon = {
        enable = lib.mkEnableOption "kmscon" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {
        services = {
          getty.autologinUser = box.userName or "alice";
          kmscon = {
            enable = true;
            config = {
              hwaccel = true;
              dpms-timeout = 300;
              grab-reboot = "<Ctrl><Alt>Delete";
              bell = true;
            }
            // lib.optionalAttrs (box.hostName == "oxygen") {
              use-original-mode = false;
              mode = "5120x2160";
              font-size = lib.mkForce 30;
            };

            useXkbConfig = true;
          };
        };
      };
    };
}
