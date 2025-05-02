{ config
, pkgs
, ...
}:

{
  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.iosevka;
      name = "Iosevka Nerd Font Mono";
      size = 14;
    };

    settings = {
      cursor_blink_interval = 0;

      scrollback_lines = 10000;
      scrollback_fill_enlarged_window = true;

      remember_window_size = false;

      mouse_hide_wait = -1;
      copy_on_select = true;
      clear_selection_on_clipboard_loss = true;
      strip_trailing_spaces = "smart";

      window_padding_width = 2;

      notify_on_cmd_finish = "invisible";
      update_check_interval = 0;
    };

    extraConfig = builtins.readFile ./theme.conf;
  };
}
