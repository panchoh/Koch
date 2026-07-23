{
  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.traits.hm.git;
    in
    {
      config = lib.mkIf cfg.enable {
        programs.gh = {
          enable = true;
          settings.git_protocol = "ssh";
          extensions = [
            pkgs.gh-eco
            pkgs.gh-dash
            pkgs.gh-enhance

            (pkgs.writeShellApplication {
              name = "gh-barewt";
              meta.mainProgram = "gh-barewt";
              derivationArgs = {
                pname = "gh-barewt";
              };
              runtimeInputs = [
                pkgs.coreutils
                config.programs.git.package
                config.programs.gh.package
                pkgs.xdg-user-dirs # for xdg-user-dir
              ];
              # bashOptions = ["errexit" "nounset" "pipefail" "xtrace"];
              # bashOptions = ["errexit" "nounset" "pipefail" "verbose"];
              text = builtins.readFile ./gh-barewt.sh;
            })
          ];
        };
      };
    };
}
