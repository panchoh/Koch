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
      cfg = config.traits.hm.go;
    in
    {
      options.traits.hm.go = {
        enable = lib.mkEnableOption "Go" // {
          default = box.isStation or false;
        };
      };

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
          pkgs.go-task
          pkgs.gotools
          pkgs.go-tools
          # REVIEW: when NixOS/nixpkgs#509480 gets addressed
          # pkgs.gopls
          (pkgs.symlinkJoin {
            name = "gopls-sans-modernize";
            paths = [ pkgs.gopls ];
            postBuild = ''
              rm -f "$out/bin/modernize"
            '';
          })
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
}
