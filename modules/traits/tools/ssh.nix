{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        ...
      }:
      let
        cfg = config.traits.os.ssh;
      in
      {
        options.traits.os.ssh = {
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
        config,
        lib,
        pkgs,
        ...
      }:
      let
        cfg = config.traits.hm.ssh;
      in
      {
        options.traits.hm.ssh = {
          enable = lib.mkEnableOption "OpenSSH" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          programs.ssh = {
            enable = true;
            enableDefaultConfig = false;
            package = pkgs.openssh;
            settings = {
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
                IdentityFile = "~/.ssh/keys.d/id_ed25519-wildcard.vm";
                ProxyCommand = "nc ( string replace .vm '' %h ) %p";
              };
              "*" = {
                AddKeysToAgent = "yes";
                ServerAliveInterval = 60;
                ControlMaster = "auto";
                ControlPath = "~/.ssh/master-%C";
                ControlPersist = "yes";
                SendEnv = [ "LC_*" ];
                IdentitiesOnly = true;
                IdentityFile = [
                  # "~/.ssh/keys.d/id_ed25519-%r@%h"
                  "~/.ssh/keys.d/id_ed25519_openpgp_YubiKey_5C_Nano-%r@%h"
                  "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#1-%r@%h"
                  "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_5C_NFC_#2-%r@%h"
                  "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#1-%r@%h"
                  "~/.ssh/keys.d/id_ed25519_sk_rk_YubiKey_C_Bio_#2-%r@%h"
                ];
                ExitOnForwardFailure = "yes";
                HostKeyAlgorithms = "ssh-ed25519";
                VisualHostKey = "yes";
              };
            };
          };
        };
      };
  };
}
