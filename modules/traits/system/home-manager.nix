{
  inputs,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.nixosModules.default =
    {
      config,
      lib,
      self,
      inputs,
      box ? null,
      ...
    }:
    let
      cfg = config.traits.os.home-manager;
    in
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];

      options.traits.os.home-manager = {
        enable = lib.mkEnableOption "Home Manager" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = box.userName != "";
            message = "userName not defined.";
          }
        ];

        home-manager = {
          extraSpecialArgs = { inherit self inputs box; };
          backupFileExtension = "backup";
          overwriteBackup = true;
          verbose = true;
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${box.userName or "alice"}.imports = [
            self.homeModules.default
          ]
          ++ box.extraHomeModules;
        };
      };
    };
}
