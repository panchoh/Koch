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
        pkgs,
        lib,
        ...
      }:

      let
        cfg = nixosConfig.traits.deploy;
      in
      {
        config = lib.mkIf cfg.enable {

          home.sessionVariables = {

            # TODO: report upstream the divergence from the desired behaviour
            # NH_ELEVATION_STRATEGY = "passwordless";

            NH_SSHOPTS = "-l deploy";
            NIX_SSHOPTS = "-l deploy";
          };

          # REVIEW: drop wrapper if this ever gets fixed
          # Notes: see above
          programs.nh.package = pkgs.symlinkJoin {
            name = "nh";
            paths = [ pkgs.nh ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            inherit (pkgs.nh) meta;
            postBuild = ''
              wrapProgram $out/bin/nh \
                --run '
                for arg in "$@"; do
                    if [[ $arg == --target-host || $arg == --target-host=* ]]; then
                        export NH_ELEVATION_STRATEGY=passwordless
                        break
                    fi
                done
              '
            '';
            passthru = {
              inherit (pkgs.hm) version;
            };
          };
        };
      };
  };
}
