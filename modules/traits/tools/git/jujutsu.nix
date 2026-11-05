{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = nixosConfig.traits.git;
    in
    {
      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.gg-jj
        ];

        programs = {

          difftastic.jujutsu.enable = true;
          delta.enableJujutsuIntegration = true;
          mergiraf.enableJujutsuIntegration = true;
          jjui.enable = true;

          starship = {

            # https://github.com/dmmulroy/jj-starship
            extraPackages = [ pkgs.jj-starship ];

            settings = {

              git_branch.disabled = true;
              git_status.disabled = true;

              custom.jj = {
                when = "jj-starship detect";
                shell = [
                  "jj-starship"
                  "--jj-symbol=󱗆 "
                ];
                format = "$output ";
              };
            };
          };

          jujutsu = {

            enable = true;

            settings = {

              ui = {
                default-command = "log";
              }
              // lib.optionalAttrs nixosConfig.traits.less.enable {
                pager.command = [
                  "less"
                  "--+clear-screen"
                  "--quit-if-one-screen"
                ];
              }
              // lib.optionalAttrs nixosConfig.traits.moor.enable {
                pager.command = [
                  "moor"
                  "--no-clear-on-exit"
                  "--no-clear-on-exit-margin=2"
                  "--quit-if-one-screen"
                ];
              };

              git = {
                colocate = false;
                sign-on-push = true;
              };

              signing = {
                behavior = "drop";
                backend = "gpg";
                key = box.gpgSigningKey;
              };

              user = {
                name = box.userDesc or "Alice Q. User";
                email = box.userEmail or "alice@example.org";
              };
            };
          };
        };
      };
    };
}
