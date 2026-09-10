{
  flake.homeModules.default =
    {
      nixosConfig,
      lib,
      ...
    }:

    let
      cfg = nixosConfig.traits.git;
    in
    {
      config = lib.mkIf cfg.enable {

        # https://worktrunk.dev/
        #
        # https://worktrunk.dev/faq/#4-metadata-in-git-automatic
        # wt config state clear
        programs.worktrunk = {

          enable = true;

          settings = {

            # https://worktrunk.dev/config/#first-run-prompts
            skip-commit-generation-prompt = true;

            # https://worktrunk.dev/faq/#3-shell-integration
            skip-shell-integration-prompt = true;

            # https://worktrunk.dev/step/#wt-step-copy-ignored
            post-start.copy = "wt step copy-ignored";

            # https://worktrunk.dev/config/#worktree-path-template, “bare repository”
            worktree-path = "{{ repo_path }}/../{{ branch | sanitize }}";
          };
        };
      };
    };
}
