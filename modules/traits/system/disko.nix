{
  flake.nixosModules.default =
    {
      self,
      inputs,
      box ? null,
      ...
    }:
    {
      imports = [
        inputs.disko.nixosModules.disko
      ];

      inherit (self.diskoConfigurations.${box.hostName}) disko;
    };
}
