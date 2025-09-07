{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.user;
in
{
  options.traits.os.user = {
    enable = lib.mkEnableOption "user" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = box.userName != "";
        message = "userName not defined";
      }
    ];

    users = {
      # Define a user account. Don't forget to set a password with ‘passwd’.
      # TODO sops/agenix would allow this:
      # mutableUsers = false;
      defaultUserShell = if !box.isStation or false then pkgs.bash else pkgs.fish;
      users.${box.userName or "alice"} = {
        isNormalUser = true;
        description = box.userDesc or "Alice Q. User";
        extraGroups = [ "wheel" ];
        initialPassword = "password";
        openssh.authorizedKeys.keys = box.userKeys;
      };
    };
  };
}
