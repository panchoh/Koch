{
  config,
  lib,
  pkgs,
  flake,
  box ? null,
  ...
}:
let
  cfg = config.traits.hm.doom-emacs;
in
{
  imports = [
    flake.inputs.nix-doom-emacs-unstraightened.homeModule
  ];

  options.traits.hm.doom-emacs = {
    enable = lib.mkEnableOption "Doom Emacs" // {
      default = box.isStation;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.doom-emacs = {
      enable = true;
      doomDir = flake.inputs.doom-config;
      emacs = pkgs.emacs-unstable-pgtk;
      experimentalFetchTree = true;
      provideEmacs = false;

      extraPackages =
        epkgs: with epkgs; [
          eglot-booster
          nix-ts-mode
          vterm
          treesit-grammars.with-all-grammars
        ];
    };

    programs.fd.enable = true;

    programs.ripgrep = {
      enable = true;
      package = pkgs.ripgrep.override { withPCRE2 = true; };
      arguments = [ "--no-config" ];
    };

    programs.amber = {
      enable = true;
      ambsSettings = {
        column = true;
        binary = true;
        skipped = true;
        recursive = true;
      };
      ambrSettings = {
        regex = true;
        row = true;
        statistics = true;
        interactive = false;
      };
    };

    home.packages = [
      (pkgs.aspellWithDicts (
        ds: with ds; [
          en
          en-computers
          en-science
        ]
      ))

      (pkgs.writeShellApplication {
        name = "doom-pristine";
        runtimeInputs = [ pkgs.coreutils ];
        text = ''
          echo 'Cleaning Doom state…'
          rm -rfv ~/.cache/doom ~/.local/state/doom ~/.local/share/doom
        '';
      })

      pkgs.nerd-fonts.symbols-only
      pkgs.emojione
      pkgs.twemoji-color-font

      pkgs.emacs-lsp-booster

      pkgs.findutils
      pkgs.coreutils
      pkgs.ddate
      pkgs.shfmt
      pkgs.shellcheck
      pkgs.nodejs_20
      pkgs.python3
      pkgs.pipenv
      pkgs.sqlite
      pkgs.duckdb

      pkgs.editorconfig-core-c

      # clang # conflits with gcc, TODO: decide which one to set here
      pkgs.gcc
      pkgs.gnumake
      pkgs.ccls

      pkgs.zig
      pkgs.zls

      pkgs.graphviz

      pkgs.tuntox # for (collab +tunnel)

      pkgs.pyright

      pkgs.go-grip
      pkgs.marksman # markdown language server

      pkgs.hugo

      pkgs.dockfmt

      pkgs.terraform

      pkgs.html-tidy
      pkgs.stylelint
      pkgs.stylelint-lsp
      pkgs.jsbeautifier

      pkgs.semgrep
      pkgs.ripgrep-all

      pkgs.bash-language-server
      pkgs.yaml-language-server
      pkgs.haskell-language-server
      pkgs.haskellPackages.hoogle
      pkgs.cabal-install

      pkgs.black
      pkgs.python313Packages.pyflakes
      pkgs.isort
      pkgs.python312Packages.pytest
      pkgs.pyenv

      pkgs.nil # nix language server
      pkgs.nixd
      pkgs.nixfmt
      pkgs.nixfmt-tree
      pkgs.deadnix

      pkgs.nixpkgs-review
      pkgs.nix-output-monitor
      pkgs.nix-fast-build
    ];

    home.sessionVariables = {
      EDITOR = lib.getBin (
        pkgs.writeShellScript "editor" ''
          exec ${lib.getExe' config.programs.emacs.finalPackage "emacsclient"} \
            --reuse-frame                                                      \
            "$@"
        ''
      );
      ALTERNATE_EDITOR = lib.getExe config.programs.neovide.package;
    };

    # TODO: enable this, but also take care of `config.doom-emacs.provideEmacs`
    services.emacs = {
      enable = false;
      defaultEditor = false;
      socketActivation.enable = false;
      # startWithUserSession = "graphical";
      client = {
        enable = true;
        arguments = [
          "--reuse-frame"
        ];
      };
    };
  };
}
