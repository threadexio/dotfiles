{ pkgs
, ...
}:

{
  boot.extraModprobeConfig = ''
    options kvm_intel nested=1
  '';

  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";

    nss.enableGuest = true;

    qemu = {
      swtpm.enable = true;
      vhostUserPackages = [ pkgs.virtiofsd ];

      verbatimConfig = ''
        nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ];
      '';
    };
  };

  environment.sessionVariables.LIBVIRT_DEFAULT_URI = "qemu:///system";

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-clone-cheap
    seabios
  ];
}
