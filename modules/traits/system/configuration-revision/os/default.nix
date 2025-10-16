{ flake, ... }:
{
  # nixos-version --configuration-revision
  system.configurationRevision = flake.rev or flake.dirtyRev;
}
