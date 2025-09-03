{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.os.hyprland;
in
{
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 51413 ];
  };
}
