{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.google-chrome;
      in
      {
        options.traits.google-chrome = {
          enable = lib.mkEnableOption "Google Chrome" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {

          nixpkgs.config.allowUnfreePackages = [ "google-chrome" ];

          programs.google-chrome = {

            enable = true ;

            commandLineArgs = [ "--ozone-platform=wayland" ];

            policies = {
              "AlwaysOpenPdfExternally" = true; # Force Google Chrome to download PDFs instead of opening them
              "AutofillAddressEnabled" = false;
              "AutofillCreditCardEnabled" = false;
              "BackgroundModeEnabled" = false;
              "BlockExternalExtensions" = true;
              "BrowserAddPersonEnabled" = false;
              "BrowserLabsEnabled" = false;
              "BrowserSignin" = 2;
              # "BrowserThemeColor" = "#282936";
              # "DnsOverHttpsMode" = "secure";
              "EnableMediaRouter" = false;
              "HideWebStoreIcon" = true;
              "IncognitoModeAvailability" = 1;
              "OsColorMode" = "dark";
              "PasswordManagerEnabled" = false;
              "PromptForDownloadLocation" = false;
              "ShowAppsShortcutInBookmarkBar" = false;
              "SpellcheckEnabled" = false;
              "SpellcheckLanguage" = [ "en-US" ];
              "SpellCheckServiceEnabled" = false;
              "ShowCastIconInToolbar" = false;
              "SyncDisabled" = false;
            };
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
        cfg = nixosConfig.traits.google-chrome;
      in
      {
        config = lib.mkIf cfg.enable {
          xdg.mimeApps.associations.removed."application/pdf" = "google-chrome.desktop";
        };
      };
  };
}
