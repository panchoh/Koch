{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.hm.git;
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
          jujutsu = {
            enable = true;
            settings = {
              ui = {
                default-command = "log";
                pager.command = [
                  "less"
                  "--+clear-screen"
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
