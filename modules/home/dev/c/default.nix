{ pkgs, ... }: {
  home.packages = with pkgs; [
    gcc
    clang-tools
  ];
}
