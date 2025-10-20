{
  flake = {
    nixosModules.default.imports = [ ../os ];
  };
}
