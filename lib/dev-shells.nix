self:
let
  inherit (self.inputs.nixpkgs.lib.attrsets) genAttrs;

  mkDevShell =
    system:
    let
      inherit (self.inputs.nixpkgs.legacyPackages.${system}) pkgs;
    in
    pkgs.mkShellNoCC {
      name = "copito--my-flaky-nixos-config";
      packages = [
        pkgs.cacert
        pkgs.nix
        pkgs.nixfmt-tree
        pkgs.nixfmt
        pkgs.git
        pkgs.go-task
        pkgs.toilet
      ];
      shellHook = ''
        echo
        toilet --font smbraille --gay "copito-my flaky NixOS config"
        echo
        task
      '';
    };

  mkDefaultDevShellForSystem = system: {
    default = mkDevShell system;
  };

  dev-shells = genAttrs self.lib.systems mkDefaultDevShellForSystem;
in
dev-shells
