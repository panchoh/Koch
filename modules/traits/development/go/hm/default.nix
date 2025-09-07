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
    home.sessionPath = [
      "$HOME/.local/bin.go"
    ];

    home.packages = [
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

    programs.go = {
      enable = true;
      goBin = ".local/bin.go";
    };
  };
}
