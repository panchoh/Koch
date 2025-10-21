{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.default =
    {
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
