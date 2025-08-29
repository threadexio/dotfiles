{ pkgs, ... }: {
  imports = [
    ./settings.nix
    ./keymap.nix
  ];

  programs.zed-editor = {
    enable = true;

    extensions = [
      "docker-compose"
      "dockerfile"
      "make"
      "nix"
      "toml"
      "xcode-themes"
    ];
  };

  home.packages = with pkgs; [
    llvmPackages.clang-tools
    nixd
  ];
}
