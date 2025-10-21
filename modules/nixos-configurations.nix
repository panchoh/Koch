{
  lib,
  self,
  ...
}:
{
  flake.nixosConfigurations =
    let
      mkNixosSystem =
        box:
        (lib.nixosSystem {
          specialArgs = { inherit box; };
          modules = [
            self.nixosModules.default
          ]
          ++ box.extraModules;
        });
    in
    self.lib.boxen
    |> map (box: lib.nameValuePair box.hostName (mkNixosSystem box))
    |> builtins.listToAttrs;
}
