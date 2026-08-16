{
  inputs,
  ...
}:

{
  flake.lib.boxen =
    let
      defaults = {
        stateVersion = "26.11";
        facter = ./facter-defaults.json;
        hostName = "nixos";
        deployGroups = [ ];
        macvlanAddr = "de:ad:be:ef:00:00";
        timeZone = "Europe/Madrid";
        isLaptop = false;
        isStation = false;
        isRestricted = false;
        hasCamera = false;
        hasBeefyGPU = false;
        hasWideDisplay = false;
        hasExternalMonitor = false;
        externalMonitorID = "DP-2";
        diskDevice = "/dev/nvme0n1";
        hasMedia = false;
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
        isLaptop = true;
        isStation = true;
        hasCamera = true;
        hasWideDisplay = true;
        hasExternalMonitor = true;
        extraModules = [ inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490 ];
      }

      {
        hostName = "aluminium";
        macvlanAddr = "68:5b:35:a7:2f:4c";
        facter = ./facter-aluminium.json;
        isLaptop = true;
        isStation = true;
        hasCamera = true;
        diskDevice = "/dev/sda";
        userName = "alpro";
        userDesc = "Alberto Peón Horrillo";
        userEmail = "alberto@peon.contact";
        githubUser = "Alberto-Peon";
        extraModules = [
          inputs.nixos-hardware.nixosModules.apple-macbook-air-5

          # BUG: facter does not detect the Bluetooth® controller on aluminium
          { config.hardware.facter.detected.bluetooth.enable = true; }

          { traits.gopass.enable = false; }
        ];
      }

      {
        hostName = "potassium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:02:8d:23";
        facter = ./facter-potassium.json;
        hasMedia = true;
        extraModules = [
          inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh
          { traits.minecraft.enable = true; }
        ];
      }

      {
        hostName = "calcium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:06:76:c0";
        facter = ./facter-calcium.json;
        hasMedia = true;
        extraModules = [ inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh ];
      }

      {
        hostName = "scandium";
        macvlanAddr = "1c:69:7a:a7:e4:e5";
        facter = ./facter-scandium.json;
        isStation = true;
        extraModules = [ inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh ];
      }

      {
        hostName = "titanium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:a7:ad:ec";
        facter = ./facter-titanium.json;
        extraModules = [ inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh ];
      }

      {
        hostName = "vanadium";
        deployGroups = [ "k8s" ];
        macvlanAddr = "1c:69:7a:a7:a8:a9";
        facter = ./facter-vanadium.json;
        diskDevice = "/dev/sda";
        extraModules = [ inputs.nixos-hardware.nixosModules.intel-nuc-8i7beh ];
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
