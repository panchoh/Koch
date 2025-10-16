{
  config,
  lib,
  pkgs,
  flake,
  ...
}:
let
  cfg = config.traits.hm.vmtools;
in
{
  options.traits.hm.vmtools = {
    enable = lib.mkEnableOption "vmtools" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      (pkgs.stdenvNoCC.mkDerivation rec {
        pname = "vmtools";
        version = flake.inputs.vmtools.rev; # Use the commit ID as the version
        src = flake.inputs.vmtools;

        buildInputs = [
          pkgs.virt-manager
          pkgs.libguestfs
          pkgs.guestfs-tools
        ];

        nativeBuildInputs = [ pkgs.makeWrapper ];

        dontUnpack = true;
        dontPatch = true;
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          mkdir -p $out/bin
          cp -r $src/bin/vm* $out/bin
        '';

        fixupPhase = ''
          for script in $out/bin/vm*; do
            substituteInPlace $script --replace-quiet sudo run0
            wrapProgram $script --prefix PATH : ${lib.makeBinPath buildInputs}
          done
        '';
      })
    ];
  };
}
