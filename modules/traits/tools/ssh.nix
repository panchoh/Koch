{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:

      let
        cfg = config.traits.ssh;
      in
      {
        options.traits.ssh = {
          enable = lib.mkEnableOption "OpenSSH and Mosh" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {

          programs = {

            mosh.enable = true;

            ssh.knownHosts = {

              # obtained by running `ssh-keyscan -t ed25519 github.com`
              "github.com".publicKey =
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
            };
          };

          services.openssh = {

            enable = true;
            startWhenNeeded = true;

            hostKeys = [
              {
                path = "/etc/ssh/ssh_host_ed25519_key";
                type = "ed25519";
              }
            ];

            settings = {
              PasswordAuthentication = false;
              KbdInteractiveAuthentication = false;
            };
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        box ? null,
        ...
      }:

      let
        cfg = nixosConfig.traits.ssh;
      in
      {
        config = lib.mkIf cfg.enable {

          home.file =
            box.pubKeys |> lib.mapAttrs' (file: key: lib.nameValuePair ".ssh/${file}" { text = "${key}\n"; });

          programs = {

            fish.shellAbbrs = {
              s = "ssh";
            };

            ssh = {

              enable = true;
              enableDefaultConfig = false;
              package = pkgs.openssh;

              settings = {

                "helium he" = {
                  Hostname = "helium";
                  LocalForward = [ "8443 127.0.0.1:443" ];
                  ProxyJump = "_gateway";
                  SessionType = "none";
                  User = "ubnt";
                };

                "ubuntu* k8s-*" = lib.hm.dag.entryBefore [ "*.vm" ] {
                  User = "sysadmin";
                  IdentityFile = "~/.ssh/keys.d/id_ed25519-sysadmin@ubuntu";
                  GlobalKnownHostsFile = "/dev/null";
                  UserKnownHostsFile = "/dev/null";
                  StrictHostKeyChecking = "no";
                };

                "*.vm" = lib.hm.dag.entryAnywhere {
                  GlobalKnownHostsFile = "/dev/null";
                  UserKnownHostsFile = "/dev/null";
                  StrictHostKeyChecking = "no";
                  # NOTE: going with the default for now (~/.ssh/id_ed25519)
                  # IdentityFile = "~/.ssh/keys.d/id_ed25519-wildcard.vm";
                  ProxyCommand = "nc ( string replace .vm '' %h ) %p";
                };

                "*" = {
                  AddKeysToAgent = "yes";
                  ServerAliveInterval = 60;
                  ControlMaster = "auto";
                  ControlPath = "~/.ssh/master-%C-%r@%h-via-%j";
                  ControlPersist = "yes";
                  SendEnv = [ "LC_*" ];
                  IdentitiesOnly = true;

                  # NOTE: going with the default for now (~/.ssh/id_ed25519)
                  # IdentityFile = [
                  #   # "~/.ssh/keys.d/id_ed25519-%r@%h"
                  #   "~/.ssh/keys.d/id_ed25519_openpgp_YubiKey_5C_Nano-%r@%h"
                  #   "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#1-%r@%h"
                  #   "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#2-%r@%h"
                  #   "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#1-%r@%h"
                  #   "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#2-%r@%h"
                  # ];

                  ExitOnForwardFailure = "yes";
                  HostKeyAlgorithms = "ssh-ed25519";
                  VisualHostKey = "yes";
                };
              };
            };
          };
        };
      };
  };
}
