{
  lib,
  self,
  inputs,
  ...
}:

{
  flake.deploy.nodes =
    let
      mkDeployNode = box: {
        hostname = box.hostName;
        profiles.system = {
          sshUser = "root";
          user = "root";
          fastConnection = true;
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${box.hostName};
        };
      };
    in
    self.lib.boxen
    |> map (box: lib.nameValuePair box.hostName (mkDeployNode box))
    |> builtins.listToAttrs;

  flake.checks = builtins.mapAttrs (
    system: deployLib: deployLib.deployChecks self.deploy
  ) inputs.deploy-rs.lib;

  flake.nixosModules.default =
    {
      config,
      lib,
      pkgs,
      ...
    }:

    let
      cfg = config.traits.os.hyprland;
    in
    {
      config = lib.mkIf cfg.enable {
        nixpkgs.overlays = [
          inputs.deploy-rs.overlays.default
          (final: prev: { deploy-rs = prev.deploy-rs.deploy-rs; })
        ];
      };
    };

  flake.homeModules.default =
    {
      config,
      lib,
      pkgs,
      box ? null,
      ...
    }:

    let
      cfg = config.traits.hm.deploy-rs;
    in
    {
      options.traits.hm.deploy-rs = {
        enable = lib.mkEnableOption "deploy-rs" // {
          default = box.isStation or false;
        };
      };

      config = lib.mkIf cfg.enable {

        home.packages = [
          pkgs.deploy-rs
        ];
      };
    };
}
