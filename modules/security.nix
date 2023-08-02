{ ... }: {
  security = {
    sudo = {
      enable = true;
      execWheelOnly = true;

      extraConfig = ''
        Defaults insults
        Defaults passwd_timeout=0
        Defaults timestamp_timeout=15
      '';
    };

    auditd.enable = true;
    audit = {
      enable = true;
    };

    polkit = {
      enable = true;
    };
  };

  boot.kernel.sysctl = {
    # Hardening
    # https://wiki.archlinux.org/title/Security#Kernel_hardening
    "kernel.sysrq" = 0;
    "kernel.kptr_restrict" = 1;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.yama.ptrace_scope" = 1;
    "kernel.kexec_load_disabled" = 1;

    "net.core.bpf_jit_harden" = 2;

    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.tcp_rfc1337" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
  };
}
