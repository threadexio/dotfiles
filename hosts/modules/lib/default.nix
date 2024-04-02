{
  # Mount a `tmpfs` filesystem.
  #
  # Parameters:
  # - `path`: Mount point.
  # - `size`: Capacity of the filesystem.
  # - `owner`: User who will own the mount. (Optional)
  # - `group`: Group who will own the mount. (Optional)
  # - `mode`: Permissions of the mount. Defaults to 0700.
  # - `extraOptions`: Additional options that should be passed to `mount`.
  #                   See: `man 5 tmpfs`. (Optional)
  mountTmpfs = { path, size, owner ? null, group ? null, mode ? "0700", extraOptions ? [ ] }:
    { config, ... }: {
      fileSystems."${path}" = {
        fsType = "tmpfs";
        options = [ "size=${size}" "mode=${mode}" "huge=always" ]

          ++ (if !(builtins.isNull owner) then [ "uid=${owner}" ] else [ ])
          ++ (if !(builtins.isNull group) then [ "gid=${group}" ] else [ ])
          ++ extraOptions

        ;
      };
    };
}
