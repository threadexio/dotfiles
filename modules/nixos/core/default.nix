{ ...
}:

{
  imports = [
    ./console.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./programs.nix
    ./security.nix
  ];

  boot.tmp.cleanOnBoot = true;
  boot.initrd.systemd.enable = true;
}
