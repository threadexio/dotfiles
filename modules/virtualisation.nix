{ pkgs, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";

    qemu = {
      ovmf = {
        enable = true;
        packages = [ pkgs.OVMFFull.fd ];
      };

      swtpm.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ seabios OVMFFull win-virtio ];
}
