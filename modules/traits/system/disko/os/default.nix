{
  flake,
  box ? null,
  ...
}:
{
  imports = [
    flake.inputs.disko.nixosModules.disko
    (import ./disk-config.nix { device = box.diskDevice or "/dev/vda"; })
  ];
}
