{ self, ... }:
{
  # nixos-version --configuration-revision
  system.configurationRevision = self.rev or self.dirtyRev;
}
