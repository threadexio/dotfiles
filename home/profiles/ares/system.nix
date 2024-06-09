{ pkgs, ... }: {
  fileSystems."/home/kat/build" = {
    fsType = "tmpfs";
    options = [ "size=10g" "mode=700" "huge=always" "uid=kat" "gid=users" ];
  };

  fileSystems."/home/kat/.cache/chromium-cache" = {
    fsType = "tmpfs";
    options = [ "size=400m" "mode=700" "uid=kat" "gid=users" "noatime" "nodev" "nosuid" ];
  };

  programs.ydotool.enable = true;
  programs.wireshark.enable = true;

  users.users.kat.extraGroups = [ "ydotool" "wireshark" ];

  environment.systemPackages = with pkgs; [ wireshark-qt ];
}
