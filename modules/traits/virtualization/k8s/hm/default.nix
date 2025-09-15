{
  config,
  lib,
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
    programs.kubecolor = {
      enable = true;
      enableAlias = true;
    };
  };
}
