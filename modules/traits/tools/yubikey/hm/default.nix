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
    home.packages = with pkgs; [
      pam_u2f
      pamtester
      libfido2

      opensc
      pcsctools
      ccid
      scmccid

      openssl

      pwgen

      yubico-piv-tool
      yubikey-manager
      yubikey-personalization
      yubikey-touch-detector
      yubioath-flutter
    ];
  };
}
