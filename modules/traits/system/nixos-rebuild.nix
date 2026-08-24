{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.os.nixos-rebuild;
    in
    {
      options.traits.os.nixos-rebuild = {
        enable = lib.mkEnableOption "nixos-rebuild" // {
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
}
