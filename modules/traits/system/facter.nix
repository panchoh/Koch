{
  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.facter;
    in
    {
      options.traits.facter = {
        enable = lib.mkEnableOption "NixOS Facter" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {

        # https://clan.lol/blog/nixos-facter/
        # https://nixos.org/manual/nixos/stable/#module-hardware-facter
        # https://search.nixos.org/options?query=facter
        # https://nix-community.github.io/nixos-facter
        # https://github.com/nix-community/nixos-facter
        # nix run .#nixosConfigurations.silicon.config.hardware.facter.debug.nvd
        # nix run .#nixosConfigurations.silicon.config.hardware.facter.debug.nix-diff
        hardware.facter.reportPath = box.facter;

        environment.systemPackages = [ pkgs.nixos-facter ];

      };
    };
}
