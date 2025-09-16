{
  config,
  lib,
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
    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    programs = {
      fish = {
        enable = true;
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
        icons = true;
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

      bat = {
        enable = true;
        config = {
          pager = "less -R";
        };
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
}
