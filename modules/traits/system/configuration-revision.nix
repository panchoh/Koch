{
  self,
  ...
}:
{
  flake.nixosModules.default = {
    # nixos-version --configuration-revision
    system.configurationRevision = self.rev or self.dirtyRev or "unknown";
  };
}
