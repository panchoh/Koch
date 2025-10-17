self:
let
  inherit (self.inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (self.inputs.nixpkgs.lib) nixosSystem;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      modules = [ self.nixosModules.default ] ++ box.extraModules;
      specialArgs = { inherit self box; };
    });

  configurations = self.lib.boxen |> map mkSystem |> builtins.listToAttrs;
in
configurations
