{
  inputs,
  ...
}:
{
  flake = {
    homeModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.autofirma;
      in
      {
        imports = [
          inputs.autofirma-nix.homeManagerModules.default
        ];

        options.traits.hm.autofirma = {
          enable = lib.mkEnableOption "AutoFirma" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          programs.autofirma = {
            enable = true;
            config = {
              omitAskOnClose = true;
              hideDnieStartScreen = true;
              useDefaultStoreInBrowserCalls = true;
              skipAuthCertDnie = true;
              # DEBUG:
              # secureConnections = false;
              #
              # Manual selection of KeyStore
              # See the names here:
              # https://github.com/ctt-gob-es/clienteafirma/blob/develop/afirma-core-keystores/src/main/java/es/gob/afirma/keystores/AOKeyStore.java
              # defaultKeystore = "SHARED_NSS";
              # defaultKeystore = "JAVA";
              # defaultKeystore = "PKCS11";
              # defaultKeystore = "MOZ_UNI";
              # defaultKeystore = "MOZ_UNI_WITH_OS";
              # defaultKeystore = "NSS";
              # defaultKeystore = "JKS";
            };
            firefoxIntegration.profiles.default.enable = config.traits.hm.firefox.enable;
          };

          programs.configuradorfnmt = {
            enable = true;
            firefoxIntegration.profiles.default.enable = config.traits.hm.firefox.enable;
          };
        };
      };
  };
}
