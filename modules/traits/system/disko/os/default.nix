{
  self,
  box ? null,
  ...
}:
{
  imports = [
    self.inputs.disko.nixosModules.disko
    (import ./disk-config.nix { device = box.diskDevice or "/dev/vda"; })
  ];
}
