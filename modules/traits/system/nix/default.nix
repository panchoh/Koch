{
  inputs,
  ...
}:

{
  flake.nixosModules.default =
    {
      config,
      lib,
      ...
    }:

    let
      cfg = config.traits.nix;
    in
    {
      options.traits.nix = {
        enable = lib.mkEnableOption "Nix" // {
          default = true;
        };
      };

      config = lib.mkIf cfg.enable {

        # NIX_PATH is still used by many useful tools, such as Doom Emacs,  so we
        # set it to the same value as the one used by this flake.  Make `nix repl
        # '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
        environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

        nix = {

          channel.enable = false;

          settings = {
            # https://nixos.org/manual/nix/unstable/command-ref/conf-file
            auto-optimise-store = true;
            use-xdg-base-directories = true;
            keep-outputs = true;
            show-trace = true;

            # NOTE: This would allow nixos-rebuild remotely with a non-trusted-user
            # Not ideal from the security standpoint, though.
            # require-sigs = false;

            allowed-users = [ ];
            trusted-users = [ "@wheel" ];

            experimental-features = [
              "nix-command"
              "flakes"
              "pipe-operators"
            ];
          };

          gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 7d";
          };
        };
      };
    };
}
