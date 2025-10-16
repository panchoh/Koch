flake:
let
  inherit (flake.inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (flake.inputs.nixpkgs.lib) nixosSystem;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      modules = [ flake.nixosModules.default ] ++ box.extraModules;
      specialArgs = { inherit flake box; };
    });

  configurations = flake.lib.boxen |> map mkSystem |> builtins.listToAttrs;
in
configurations
