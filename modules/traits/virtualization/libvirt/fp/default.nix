{
  flake = {
    nixosModules.default.imports = [ ../os ];
    homeModules.default.imports = [ ../hm ];
  };
}
