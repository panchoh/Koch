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
          env.GOBIN = "${config.xdg.binHome}";
        };

        home = {
          packages = [
            pkgs.capslock
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
