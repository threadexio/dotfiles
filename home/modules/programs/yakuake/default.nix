{ pkgs, ... }: {
  home.packages = with pkgs.kdePackages; [ konsole yakuake ];
}
