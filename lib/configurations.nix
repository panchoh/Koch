flake:
let
  inherit (flake.inputs.nixpkgs.lib.attrsets) nameValuePair;
  inherit (flake.inputs.nixpkgs.lib) nixosSystem;

  mkSystem =
    box:
    nameValuePair box.hostName (nixosSystem {
      modules = [ flake.nixosModules.default ] ++ box.extraModules;
      specialArgs = flake.inputs // {
        inherit box;
        home.imports = [ flake.homeModules.default ] ++ box.extraHomeModules;
        extraSpecialArgs = flake.inputs // {
          inherit box;
        };
      };
    });

  configurations = flake.lib.boxen |> map mkSystem |> builtins.listToAttrs;
in
configurations
