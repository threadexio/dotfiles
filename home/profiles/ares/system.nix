{ ... }: {
  fileSystems."/home/kat/build" = {
    fsType = "tmpfs";
    options = [ "size=10g" "mode=700" "huge=always" "uid=kat" "gid=users" ];
  };
}
