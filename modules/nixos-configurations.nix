{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      inherit (inputs.nixpkgs.lib.attrsets) nameValuePair;
      inherit (inputs.nixpkgs.lib) nixosSystem;

      mkSystem =
        box:
        nameValuePair box.hostName (nixosSystem {
          specialArgs = { inherit self inputs box; };
          modules = [
            self.nixosModules.default
          ]
          ++ box.extraModules;
        });

    in
    self.lib.boxen |> map mkSystem |> builtins.listToAttrs;
}
