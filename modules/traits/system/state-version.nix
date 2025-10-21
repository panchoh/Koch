{
  flake = {
    nixosModules.default =
      {
        box ? null,
        ...
      }:
      {
        system.stateVersion = box.stateVersion;
      };

    homeModules.default =
      {
        box ? null,
        ...
      }:
      {
        home.stateVersion = box.stateVersion;
      };
  };
}
