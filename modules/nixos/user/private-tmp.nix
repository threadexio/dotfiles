{ ...
}:

{
  systemd.tmpfiles.settings.kat-private-tmp."/tmp/kat".d = {
    user = "kat";
    group = "users";
    mode = "700";
  };
}
