{
  lib,
  self,
  inputs,
  ...
}:

{
  flake = {
    deploy = {

      sudo = "run0 --user";

      nodes =
        let
          mkDeployNode = box: {

            hostname = box.hostName;

            profiles.system = {

              sshUser = "deploy"; # REVIEW: dep traits/deploy
              user = "root";
              fastConnection = true;
              groups = box.deployGroups;

              path = inputs.deploy-rs.lib.${box.system}.activate.nixos self.nixosConfigurations.${box.hostName};
            };
          };
        in
        self.lib.boxen
        |> map (box: lib.nameValuePair box.hostName (mkDeployNode box))
        |> builtins.listToAttrs;
    };

    checks =
      inputs.deploy-rs.lib |> builtins.mapAttrs (_system: deployLib: deployLib.deployChecks self.deploy);

    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:

      let
        cfg = config.traits.deploy-rs;
      in
      {
        options.traits.deploy-rs = {
          enable = lib.mkEnableOption "deploy-rs" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          nixpkgs.overlays = [
            inputs.deploy-rs.overlays.default
            (_final: prev: { deploy-rs = prev.deploy-rs.deploy-rs; })
          ];
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.deploy-rs;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [
            pkgs.deploy-rs
          ];
        };
      };
  };
}
