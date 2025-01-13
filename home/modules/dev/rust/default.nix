{ config, pkgs, ... }: {
  home.sessionPath = [
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  home.packages = with pkgs; [
    rustup
  ];
}
