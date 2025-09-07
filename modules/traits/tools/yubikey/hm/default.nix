{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.yubikey;
in
{
  options.traits.hm.yubikey = {
    enable = lib.mkEnableOption "YubiKey" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pam_u2f
      pkgs.pamtester
      pkgs.libfido2

      pkgs.opensc
      pkgs.pcsctools
      pkgs.ccid
      pkgs.scmccid

      pkgs.openssl

      pkgs.pwgen

      pkgs.yubico-piv-tool
      pkgs.yubikey-manager
      pkgs.yubikey-personalization
      pkgs.yubikey-touch-detector
      pkgs.yubioath-flutter
    ];
  };
}
