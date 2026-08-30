{
  inputs,
  ...
}:

{
  flake.lib.boxen =
    let
      defaults = {
        stateVersion = "26.11";
        system = "x86_64-linux"; # FIXME: apps-disko-and-funk depends on it #facter
        facter = ./facter-defaults.json;
        hostName = "nixos";
        deployGroups = [ ];
        macvlanAddr = "de:ad:be:ef:00:00";
        timeZone = "Europe/Madrid";
        isStation = false;
        isRestricted = false;
        hasBeefyGPU = false;
        hasWideDisplay = false;
        diskDevice = "/dev/nvme0n1";
        userName = "pancho";
        userDesc = "pancho horrillo";
        userEmail = "pancho@pancho.name";
        githubUser = "panchoh";
        flakeRepoName = "Koch";
        gpgSigningKey = "4430F5028B19FAF4A40EC4E811E0447D4ABBA7D0";
        virtualHost = "canalplus.pancho.name";
        virtualHostRoot = "FF2E6E41-1FE8-4515-82D1-56D5C49EB2B5";
        pubKeys = {
          "id_ed25519.pub" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhtv6KrJc04bydU2mj6j/V6g/g+RiY1+gTg9h4z3STm pancho";
          "id_ed25519-pancho@ipad.pub" =
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE82Jevn/TyeGN1lQbDfUsY6oaE/6/AC9OrTBL/5IErW pancho@ipad";
        };
        extraModules = [ ];
        extraHomeModules = [ ];
      };
    in
    [
      {
        hostName = "nixos";
        deployGroups = [ "vm" ];
        diskDevice = "/dev/vda";
      }

      {
        hostName = "oxygen";
        macvlanAddr = "48:21:0b:3c:16:a9";
        facter = ./facter-oxygen.json;
        isStation = true;
        hasBeefyGPU = true;
        hasWideDisplay = true;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-12wshi7
          { traits.caddy.enable = true; }
        ];
      }

      {
        hostName = "magnesium";
        macvlanAddr = "00:2b:67:11:27:06";
        facter = ./facter-magnesium.json;
        isStation = true;
        hasWideDisplay = true;
        extraModules = [
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490
          { hardware.trackpoint.emulateWheel = false; }

          # NOTE: should be whiskey-lake, but comet-lake sets hardware.intelgpu.computeRuntime = "legacy";
          # whereas whiskey-lake does not, being an older generation.
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake

          # REVIEW: uncomment when https://github.com/NixOS/nixos-hardware/pull/2001 gets merged
          # https://github.com/NixOS/nixos-hardware/issues/992#issuecomment-4105165706
          # { imports = [ "${inputs.nixos-hardware}/common/gpu/intel/whiskey-lake" ]; }

          # REVIEW: re-enable when hyprpolkitagent supports it
          # https://redirect.github.com/hyprwm/hyprpolkitagent/issues/24
          { hardware.facter.detected.fingerprint.enable = false; }
        ];
      }

      {
        hostName = "aluminium";
        macvlanAddr = "68:5b:35:a7:2f:4c";
        facter = ./facter-aluminium.json;
        isStation = true;
        diskDevice = "/dev/sda";
        userName = "alpro";
        userDesc = "Alberto Peón Horrillo";
        userEmail = "alberto@peon.contact";
        githubUser = "Alberto-Peon";
        extraModules = [
          inputs.nixos-hardware.nixosModules.apple-macbook-air-5

          # REVIEW: uncomment when facetimehd driver gets updated to work with linux 7.2.0
          # {
          #   hardware.facetimehd = {
          #     enable = true;
          #     withCalibration = true;
          #   };

          #   nixpkgs.config.allowUnfreePackages = [
          #     "intel-ocl"
          #     "facetimehd-firmware"
          #     "facetimehd-calibration"
          #   ];
          # }

          # BUG: facter does not detect the Bluetooth® controller on aluminium
          { hardware.facter.detected.bluetooth.enable = true; }

          { traits.gopass.enable = false; }
        ];
      }

      {
        hostName = "phosphorus";
        macvlanAddr = "1c:69:7a:a7:e4:e5";
        facter = ./facter-phosphorus.json;
        isStation = true;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake
        ];
      }

      {
        hostName = "potassium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:02:8d:23";
        facter = ./facter-potassium.json;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake
          { traits.minecraft.enable = true; }
        ];
      }

      {
        hostName = "calcium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:06:76:c0";
        facter = ./facter-calcium.json;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake
        ];
      }

      {
        hostName = "titanium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:a7:ad:ec";
        facter = ./facter-titanium.json;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake
        ];
      }

      {
        hostName = "vanadium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:a7:a8:a9";
        facter = ./facter-vanadium.json;
        diskDevice = "/dev/sda";
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          inputs.nixos-hardware.nixosModules.common-gpu-intel-comet-lake
        ];
      }

      {
        hostName = "selenium";
        macvlanAddr = "c8:d3:ff:43:8f:70";
        facter = ./facter-selenium.json;
        isStation = true;
        hasBeefyGPU = true;
        extraModules = [
          {
            hardware.nvidia.open = true;

            nixpkgs.config.allowUnfreePackages = [
              "nvidia-settings"
              "nvidia-x11"
            ];

            services.xserver.videoDrivers = [ "nvidia" ];
          }
        ];
      }

      # FIXME: this flake is still x86_64 centric, so it can't yet configure my Raspberry Pi 4
      # {
      #   system = "aarch64-linux";
      #   hostName = "neon";
      #   macvlanAddr = "dc:a6:32:b1:ae:1d";
      #   extraModules = [ inputs.nixos-hardware.nixosModules.raspberry-pi-4 ];
      # }

    ]
    |> map (overrides: defaults // overrides);
}
