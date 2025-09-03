{
  config,
  lib,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.nix-init;
in
{
  options.traits.hm.nix-init = {
    enable = lib.mkEnableOption "nix-init" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nix-init = {
      enable = true;
      settings = {
        commit = true;
        maintainers = [
          box.githubUser
        ];
      };
    };
  };
}
