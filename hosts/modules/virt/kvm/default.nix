{ pkgs, ... }: {
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";

    nss.enableGuest = true;

    qemu = {
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };

      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];

      verbatimConfig = ''
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ];
      '';
    };
  };

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-clone-cheap
    seabios
  ];
}
