{
  inputs,
  ...
}:

{
  flake = {
    nixosModules.default =
      {
        lib,
        ...
      }:

      {
        options.traits.vmtools = {
          enable = lib.mkEnableOption "vmtools" // {
            default = true;
          };
        };
      };

    homeModules.default =
      {
        nixosConfig,
        lib,
        pkgs,
        ...
      }:

      let
        cfg = nixosConfig.traits.vmtools;
      in
      {
        config = lib.mkIf cfg.enable {

          home.packages = [

            (pkgs.stdenvNoCC.mkDerivation rec {
              pname = "vmtools";
              version = inputs.vmtools.rev; # Use the commit ID as the version
              src = inputs.vmtools;

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
      };
  };
}
