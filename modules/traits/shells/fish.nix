{
  flake = {
    nixosModules.default =
      {
        config,
        lib,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.os.fish;
      in
      {
        options.traits.os.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          programs = {
            less.enable = lib.mkForce false;
            fish = {
              enable = true;
              useBabelfish = true;
              interactiveShellInit = ''
                set -g fish_greeting
              '';
            };
          };
        };
      };

    homeModules.default =
      {
        config,
        lib,
        pkgs,
        box ? null,
        ...
      }:
      let
        cfg = config.traits.hm.fish;
      in
      {
        options.traits.hm.fish = {
          enable = lib.mkEnableOption "fish" // {
            default = box.isStation or false;
          };
        };

        config = lib.mkIf cfg.enable {
          programs = {
            fish = {
              enable = true;
              shellAbbrs = {
                g = "git";
                l = "less";
                t = "task";
                "..." = "../..";
              };
              shellAliases = {
                e = "$EDITOR --no-wait";
              };
            };

            starship = {
              enable = true;
              settings = {
                hostname = {
                  ssh_only = false;
                };
                golang = {
                  symbol = " ";
                };
              };
            };

            atuin = {
              enable = true;
              flags = [
                "--disable-up-arrow"
              ];
              settings = {
                auto_sync = false;
                common_prefix = [ "run0" ];
                dotfiles.enabled = false;
                enter_accept = true;
                exit_mode = "return-query";
                sync.records = true;
                workspaces = true;
              };
            };

            lsd = {
              enable = true;
              settings = {
                date = "relative";
                header = true;
                icons = {
                  when = "auto";
                  separator = "  ";
                  theme = "fancy";
                };
                indicators = true;
                sorting.dir-grouping = "first";
                literal = true;
                total-size = false;
                ignore-globs = [
                  ".git"
                  ".hg"
                ];
                blocks = [
                  "permission"
                  "links"
                  # "inode"
                  "user"
                  "group"
                  # "context"
                  "size"
                  "date"
                  "git"
                  "name"
                ];
              };
            };

            eza = {
              enable = false;
              git = true;
              icons = "auto";
              extraOptions = [
                "--binary"
                # "--context"
                "--git-repos-no-status"
                "--group-directories-first"
                "--group"
                "--extended"
                "--header"
                # "--inode"
                "--links"
                "--mounts"
                "--time-style=relative"
              ];
            };

            less = {
              enable = true;
              options = lib.mkMerge [
                {
                  clear-screen = false;
                  form-feed = true;
                  incsearch = true;
                  Long-Prompt = true;
                  mouse = true;
                  no-histdups = true;
                  quit-at-eof = true;
                  quit-if-one-screen = true;
                  Raw-Control-Chars = true;
                  redraw-on-quit = true;
                  save-marks = true;
                  status-column = true;
                  status-line = false;
                  use-color = true;
                  wheel-lines = 3;
                }
                # Ordering issue fixed on https://github.com/nix-community/home-manager/pull/8204
                (lib.mkAfter {
                  color = [
                    "Pkmsd"
                    "Mkmsd"
                  ];
                })
              ];
            };

            bat = {
              enable = true;
              config = {
                italic-text = "always";
                paging = "always";
                style = "full";
              };
              extraPackages = with pkgs.bat-extras; [
                batdiff
                batman
                batgrep
                batwatch
              ];
            };

            fzf = {
              enable = false;
              defaultCommand = "fd --type f";
              defaultOptions = [
                "--height 40%"
                "--border"
              ];
              fileWidgetCommand = "fd --type f";
              fileWidgetOptions = [
                "--preview 'head {}'"
              ];
              tmux = {
                enableShellIntegration = true;
                shellIntegrationOptions = [ "-d 40%" ];
              };
            };

            television = {
              enable = true;
              settings = {
                default_channel = "nix-search-tv";
                ui = {
                  status_bar = {
                    separator_open = "";
                    separator_close = "";
                  };
                  theme = "dracula";
                };
              };
            };

            nix-search-tv = {
              enable = true;
              settings.experimental.render_docs_indexes.nvf = "https://notashelf.github.io/nvf/options.html";
            };

            pay-respects.enable = true;

            jq.enable = true;

            tealdeer = {
              enable = true;
              settings.updates.auto_update = true;
            };

            # https://dystroy.org/broot/
            # TODO: explore the tool and configure verbs et al.
            broot = {
              enable = true;
              settings = {
                modal = true;
              };
            };

            lf = {
              enable = true;
              settings = {
                icons = true;
                sixel = true;
              };
            };

            yazi = {
              enable = true;
              enableFishIntegration = true;
            };
          };
        };
      };
  };
}
