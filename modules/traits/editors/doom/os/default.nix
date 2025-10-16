{
  config,
  lib,
  flake,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.doom-emacs;
in
{
  options.traits.os.doom-emacs = {
    enable = lib.mkEnableOption "Doom Emacs" // {
      default = box.isStation;
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      flake.inputs.emacs-overlay.overlays.default
    ];
  };
}
