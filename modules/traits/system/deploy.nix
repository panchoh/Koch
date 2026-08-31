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
        cfg = config.traits.deploy;
      in
      {
        options.traits.deploy = {
          enable = lib.mkEnableOption "deploy" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {

          users.groups.deploy = { };

          users.users.deploy = {
            description = "Remote deployment automation user";
            group = "deploy";
            isSystemUser = true;
            shell = pkgs.bashNonInteractive;

            # FIXME: fragile
            openssh.authorizedKeys.keys = [
              "restrict ${(builtins.attrValues box.pubKeys) |> lib.reverseList |> builtins.head}"
            ];
          };

          nix.settings = {
            allowed-users = [ "@wheel" ];
            trusted-users = [ "@deploy" ];
          };

          security.polkit = {

            enable = true;

            extraConfig = ''
              polkit.addRule(function(action, subject) {
                if (action.id == "org.freedesktop.systemd1.manage-units" &&
                    subject.isInGroup("deploy")) {
                    return polkit.Result.YES;
                }
              });
            '';
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
        cfg = nixosConfig.traits.deploy;
      in
      {
        config = lib.mkIf cfg.enable {
          home.sessionVariables = {
            NH_ELEVATION_STRATEGY = "passwordless";
            NH_SSHOPTS = "-l deploy";
            NIX_SSHOPTS = "-l deploy";
          };
        };
      };
  };
}
