{ pkgs, ... }@args: {
  programs.zed-editor = {
    enable = true;

    userSettings = import ./settings.nix args;
    userKeymaps = import ./keymap.nix args;
  };

  home.packages = with pkgs; [
    llvmPackages.clang-tools
    nixd
  ];
}
