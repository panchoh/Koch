{
  description = "Nix is love.  Nix is life.  But Nix is also… snow.";

  nixConfig = {
    abort-on-warn = true;
    allow-import-from-derivation = true; # for nix-doom-emacs-unstraightened
    extra-experimental-features = [ "pipe-operators" ];
    commit-lockfile-summary = "chore(flake): bump";
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
    flake-parts.url = "flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    nixos-hardware.url = "nixos-hardware";
    disko.url = "disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.systems.follows = "systems";
    stylix.inputs.flake-parts.follows = "flake-parts";
    autofirma-nix.url = "github:nix-community/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
    autofirma-nix.inputs.flake-parts.follows = "flake-parts";
    autofirma-nix.inputs.home-manager.follows = "home-manager";
    emacs-overlay.url = "emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
    emacs-overlay.inputs.nixpkgs-stable.follows = "nixpkgs";
    doomemacs.url = "github:doomemacs/doomemacs";
    doomemacs.flake = false;
    doom-config.url = "github:panchoh/doom";
    doom-config.flake = false;
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
    nix-doom-emacs-unstraightened.inputs.nixpkgs.follows = "";
    nix-doom-emacs-unstraightened.inputs.systems.follows = "systems";
    nix-doom-emacs-unstraightened.inputs.emacs-overlay.follows = "emacs-overlay";
    nix-doom-emacs-unstraightened.inputs.doomemacs.follows = "doomemacs";
    nvf.url = "github:NotAShelf/nvf";
    nvf.inputs.nixpkgs.follows = "nixpkgs";
    nvf.inputs.systems.follows = "systems";
    nvf.inputs.flake-parts.follows = "flake-parts";
    vmtools.url = "github:4km3/vmtools";
    vmtools.flake = false;
    kubelab.url = "github:4km3/kubelab";
    kubelab.flake = false;
  };

  outputs =
    { self, ... }:
    {
      lib = import ./lib self;
      formatter = import ./lib/nixfmt-tree.nix self;
      apps = import ./lib/apps-disko-and-funk.nix self;
      devShells = import ./lib/dev-shells.nix self;
      homeModules.default = import ./lib/module.nix self "hm";
      nixosModules.default = import ./lib/module.nix self "os";
      nixosConfigurations = import ./lib/configurations.nix self;
    };
}
