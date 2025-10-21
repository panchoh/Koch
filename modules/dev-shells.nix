{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "Koch";

        packages = [
          pkgs.cacert
          pkgs.nix
          pkgs.nixfmt-tree
          pkgs.nixfmt
          pkgs.git
          pkgs.go-task
          pkgs.jq
          pkgs.toilet
        ];

        shellHook = ''
          echo
          toilet --font smbraille --gay "Koch-my flaky NixOS config"
          echo
          task
        '';
      };
    };
}
