{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.yubikey;
      in
      {
        options.traits.yubikey = {
          enable = lib.mkEnableOption "YubiKey" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {

          hardware.gpgSmartcards.enable = true;

          nixpkgs.config.allowUnfreePackages = [ "scmccid" ];

          services = {
            pcscd.enable = true;
            udev.packages = [ pkgs.yubikey-personalization ];
          };

          security = {

            pam = {
              u2f = {
                enable = true;
                settings.cue = true;
              };

              services = {
                login.u2fAuth = true;
                run0.u2fAuth = true;
              };
            };
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
        cfg = nixosConfig.traits.yubikey;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [

            pkgs.pam_u2f
            pkgs.pamtester
            pkgs.libfido2

            pkgs.opensc
            pkgs.pcsc-tools
            pkgs.ccid
            pkgs.scmccid

            pkgs.openssl

            pkgs.pwgen
            pkgs.rusty-diceware # https://gitlab.com/yuvallanger/rusty-diceware

            pkgs.yubico-piv-tool
            pkgs.yubikey-manager
            pkgs.yubikey-personalization
            pkgs.yubikey-touch-detector
            pkgs.yubioath-flutter
          ];
        };
      };
  };
}
