{
  description = "Nix is love.  Nix is life.  But Nix is also… snow.";

  nixConfig.commit-lockfile-summary = "chore(flake): bump";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    stylix.inputs.home-manager.follows = "home-manager";
    autofirma-nix.url = "github:nilp0inter/autofirma-nix";
    autofirma-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    lib = import ./lib inputs // import ./modules/lib inputs;

    formatter = self.lib.fmt-alejandra;

    apps =
      builtins.foldl' (
        acc: box:
          acc
          // {
            ${box.system} =
              (acc.${box.system} or {})
              // {
                ${box.hostName} = {
                  type = "app";
                  program = "${self.nixosConfigurations."${box.hostName}".config.system.build.diskoScript}";
                };
              };
          }
      ) {}
      self.lib.boxen;

    # apps."x86_64-linux".default = self.apps."x86_64-linux"."nixos";

    nixosModules.default = self.lib.nixosModule;

    nixosConfigurations = builtins.listToAttrs (
      map (box: {
        name = box.hostName;
        value = nixpkgs.lib.nixosSystem {
          inherit (box) system;
          modules = [
            box.hostType
            box.extraModule
            self.lib.nixosModule
          ];
          specialArgs =
            inputs
            // {
              inherit box;
              inherit (self.lib) hmModule;
            };
        };
      })
      self.lib.boxen
    );
  };
}
