{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
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

          # Kubelet does not support running with swap
          # TODO: this doesn't prevent swapon from being run on bootup!
          swapDevices = lib.mkForce [ ];

          services.kubernetes = {
            masterAddress = "localhost";
            roles = [
              "master"
              "node"
            ];
          };
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.k8s;
      in
      {
        options.traits.hm.k8s = {
          enable = lib.mkEnableOption "Kubernetes" // {
            default = !box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.talosctl
            pkgs.cri-tools
            pkgs.kubectl
          ];
          programs.kubecolor = {
            enable = true;
            enableAlias = true;
          };
        };
      };
  };
}
