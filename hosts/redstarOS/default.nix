{ pkgs, lib, ... }: {
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "net.ifnames=0" "intel_iommu=on" "iommu=pt" ];

    extraModprobeConfig = ''
      options kvm_intel nested=1
      options snd_hda_intel power_save=1
    '';
  };

  services.fwupd.enable = true;
  security.tpm2.enable = true;
  services.usbguard = {
    enable = true;

    rules = ''
      allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
      allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "3Wo3XWDgen1hD5xM3PSNl3P98kLp1RUTgGQ5HSxtf8k=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
      allow id 1b1c:1b3e serial "04033021AF0E98A95948D01FF5001946" name "Corsair Gaming SCIMITAR PRO RGB Mouse" hash "z9uL2dgt5m5Tqb2ikDf6/F2bgpOa/qYGn4C/mixuD40=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 03:01:02 03:00:00 } with-connect-type "hotplug"
      allow id 048d:c100 serial "" name "ITE Device(8910)" hash "NQuzt8wH32Iij7gOWRymiM/3IRmBqioyUDc8SYfOmzI=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-9" with-interface 03:01:01 with-connect-type "hardwired"
    '';
  };

  networking.hostName = "redstarOS";

  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";

  services.flatpak.enable = true;
  hardware.ckb-next.enable = true;

  powerManagement = {
    enable = lib.mkForce false;
    cpuFreqGovernor = "powersave";
    powertop.enable = true;
  };

  users.users = {
    kat = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" "wireshark" ];

      shell = pkgs.zsh;

      createHome = true;
      homeMode = "700";

      # Rootless podman containers
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
  };
}
