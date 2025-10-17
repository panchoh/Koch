self:
let
  inherit (self.inputs.nixpkgs) legacyPackages;
  inherit (self.inputs.nixpkgs.lib.attrsets) genAttrs;

  nixFmtTreeForSystem = system: legacyPackages.${system}.nixfmt-tree;

  nixfmt-tree = genAttrs self.lib.systems nixFmtTreeForSystem;
in
nixfmt-tree
