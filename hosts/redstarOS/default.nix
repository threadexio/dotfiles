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

  services.hardware.bolt.enable = true;
  services.fwupd.enable = true;
  security.tpm2.enable = true;
  services.usbguard = {
    enable = true;

    rules = ''
allow id 1d6b:0002 serial "0000:00:14.0" name "xHCI Host Controller" hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
allow id 1d6b:0003 serial "0000:00:14.0" name "xHCI Host Controller" hash "3Wo3XWDgen1hD5xM3PSNl3P98kLp1RUTgGQ5HSxtf8k=" parent-hash "rV9bfLq7c2eA4tYjVjwO4bxhm+y6GgZpl9J60L0fBkY=" with-interface 09:00:00 with-connect-type ""
allow id 1d6b:0002 serial "0000:3b:00.0" name "xHCI Host Controller" hash "YzNlUg555LUqKT3BwVzKb/M5Av3rHSzUkShpUmtv4Yo=" parent-hash "C4sxfinbNc4ERzx5G6ZFgmB833/oJDyZu2j+tWRGXLQ=" with-interface 09:00:00 with-connect-type ""
allow id 1d6b:0003 serial "0000:3b:00.0" name "xHCI Host Controller" hash "JF1EpD/Z/zPMsM9Z0zaZn4eerhHZzE8zfmOXfMgHgag=" parent-hash "C4sxfinbNc4ERzx5G6ZFgmB833/oJDyZu2j+tWRGXLQ=" with-interface 09:00:00 with-connect-type ""
allow id 1b1c:1ba4 serial "F5001BC46041EFDEAF8A0D230B02C027" name "CORSAIR K55 RGB PRO Gaming Keyboard" hash "I7dn2Qo3vvfklagyKsd++CjUBSRpIjhpHlE4/9Ro9kM=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 03:01:01 03:00:00 03:00:00 } with-connect-type "hotplug"
allow id 1b1c:1b3e serial "04033021AF0E98A95948D01FF5001946" name "Corsair Gaming SCIMITAR PRO RGB Mouse" hash "z9uL2dgt5m5Tqb2ikDf6/F2bgpOa/qYGn4C/mixuD40=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" with-interface { 03:01:02 03:00:00 } with-connect-type "hotplug"
allow id 048d:c100 serial "" name "ITE Device(8910)" hash "NQuzt8wH32Iij7gOWRymiM/3IRmBqioyUDc8SYfOmzI=" parent-hash "jEP/6WzviqdJ5VSeTUY8PatCNBKeaREvo2OqdplND/o=" via-port "1-9" with-interface 03:01:01 with-connect-type "hardwired"
allow id 04b4:6506 serial "" name "" hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" parent-hash "YzNlUg555LUqKT3BwVzKb/M5Av3rHSzUkShpUmtv4Yo=" via-port "3-1" with-interface { 09:00:01 09:00:02 } with-connect-type "unknown"
allow id 04b4:6504 serial "" name "" hash "zYs+AzHULIcaBfrw1iIaej077riqAR/Sb+ec6dViGc0=" parent-hash "JF1EpD/Z/zPMsM9Z0zaZn4eerhHZzE8zfmOXfMgHgag=" via-port "4-1" with-interface 09:00:00 with-connect-type "unknown"
allow id 04b4:6506 serial "" name "" hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" parent-hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" via-port "3-1.1" with-interface { 09:00:01 09:00:02 } with-connect-type "unknown"
allow id 03f0:484a serial "0001" name "HP Elite USB-C Dock G4" hash "NR9YrZzRLLl6ZkQsDsVZgxuGYllCZbitNu3XSN/+Sb0=" parent-hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" with-interface { 11:00:00 03:00:00 } with-connect-type "unknown"
allow id 04b4:6504 serial "" name "" hash "zYs+AzHULIcaBfrw1iIaej077riqAR/Sb+ec6dViGc0=" parent-hash "zYs+AzHULIcaBfrw1iIaej077riqAR/Sb+ec6dViGc0=" via-port "4-1.1" with-interface 09:00:00 with-connect-type "unknown"
allow id 0bda:8153 serial "421561000000" name "USB 10/100/1000 LAN" hash "jv+MMdE6Mjhgs7rDsv2P5lj4nWbUxVxKbon7FAA40Tg=" parent-hash "zYs+AzHULIcaBfrw1iIaej077riqAR/Sb+ec6dViGc0=" with-interface { ff:ff:00 02:06:00 0a:00:00 0a:00:00 } with-connect-type "unknown"
allow id 04b4:6572 serial "000000000000" name "HX2VL" hash "5pBuOzuU+UhNO345IOhyMWvsJglAeYYcNhtO8w+rR1E=" parent-hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" with-interface 09:00:00 with-connect-type "unknown"
allow id 0bda:482a serial "201405280001" name "USB Audio" hash "b41aclcyt8xC5ZbQZq0zxBcvqzenczErRuGJyktmU3U=" parent-hash "4Sr2ku5SbYdd094Tf5zsxxuDHv+qT5+5np03tKXBLis=" with-interface { 01:01:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 01:02:00 03:00:00 } with-connect-type "unknown"
allow id 2717:ff40 serial "18cf508f" name "Redmi Note 8T" hash "kQS3cvakjSDjBA/+utSgdG5yq5motAnqBEbfH1cSVM8=" parent-hash "5pBuOzuU+UhNO345IOhyMWvsJglAeYYcNhtO8w+rR1E=" with-interface ff:ff:00 with-connect-type "unknown"
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
