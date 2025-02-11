{ pkgs, ... }: {

  home.packages = with pkgs; [
    # Man pages
    man-pages
    man-pages-posix

    # Debuggers & Profilers
    gdb
    strace
    ltrace
    valgrind
    nmap # ncat
    dig
  ];
}
