{ pkgs, ... }: {
  programs = {
    gnupg.agent.enable = true;
    git.enable = true;

    wireshark.enable = true;
  };

  documentation = {
    man.enable = true;
    nixos.enable = true;
    dev.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # IDEs
    vscode

    ## Nix
    nixpkgs-fmt
    nil

    ## Rust
    rustup

    ## Python
    python3

    # Debuggers & Profilers
    gdb
    lldb
    strace
    ltrace
    valgrind
    nmap # ncat
    dig
  ];
}
