{
  config,
  lib,
  pkgs,
  box ? null,
  ...
}:
let
  cfg = config.traits.os.neovim;
in
{
  options.traits.os.neovim = {
    enable = lib.mkEnableOption "Neovim" // {
      default = box.isStation or false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs = {
      nano.enable = false;
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        configure = {
          customRC = ''
            set mouse=
          '';
          packages.myVimPackage = {
            start = [ pkgs.vimPlugins.vim-nix ];
          };
        };
      };
    };

    environment.variables.EDITOR = "nvim";
  };
}
