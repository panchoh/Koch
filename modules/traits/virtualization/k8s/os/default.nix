{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.k8s;
in
{
  options.traits.os.k8s = {
    enable = lib.mkEnableOption "Kubernetes" // {
      default = !box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    # REVIEW: Remove when https://nixpkgs-tracker.ocfox.me/?pr=TBD gets through
    systemd.services.kube-certmgr-bootstrap.enableStrictShellChecks = false;

    services.kubernetes = {
      masterAddress = "localhost";
      roles = [
        "master"
        "node"
      ];
    };
    environment.systemPackages = [
      pkgs.kubectl
      pkgs.cri-tools
      # pkgs.kubernetes
      pkgs.talosctl
    ];
  };
}
