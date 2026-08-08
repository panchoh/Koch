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
            default = !(box.isStation or true);
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
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            pkgs.cri-tools
            pkgs.kubectl # TODO: deploy only on master node(s)
          ]
          ++ lib.optionals box.isStation or false [
            # https://docs.siderolabs.com/talos/latest/overview/what-is-talos
            pkgs.talosctl
            pkgs.talos-pilot
            pkgs.talm
            pkgs.talhelper
          ];

          programs.kubecolor = {
            enable = box.isStation or false;
            enableAlias = box.isStation or false;
          };
        };
      };
  };
}
