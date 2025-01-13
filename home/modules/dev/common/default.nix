{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Man pages
    man-pages
    man-pages-posix

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
