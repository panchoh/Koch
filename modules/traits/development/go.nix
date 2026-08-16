{
  flake = {
    nixosModules.default =
      {
        lib,
        box ? null,
        ...
      }:

      {
        options.traits.go = {
          enable = lib.mkEnableOption "Go" // {
            default = box.isStation or false;
          };
        };
      };

    homeModules.default =
      {
        config,
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.go;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.go = {
            enable = true;

            env = {
              GOPATH = "${config.xdg.dataHome}/go";
              GOBIN = "${config.xdg.binHome}";
              GOMODCACHE = "${config.xdg.cacheHome}/go-mod";
            };
          };

          home.packages = [
            pkgs.capslock
            pkgs.govulncheck
            pkgs.go-task
            pkgs.gotools
            pkgs.go-tools
            pkgs.gopls
            pkgs.gofumpt
            pkgs.gomodifytags
            pkgs.gotests
            pkgs.gore
            pkgs.godef
            pkgs.delve
            pkgs.gdlv
            pkgs.golangci-lint
          ];
        };
      };
  };
}
