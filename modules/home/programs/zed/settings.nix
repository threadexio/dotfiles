{ pkgs
, ...
}:

{
  programs.zed-editor.userSettings = {
    theme = "Xcode High Contrast Darker";
    base_keymap = "VSCode";

    ##
    ## Fonts
    ##

    ui_font_family = "Noto Sans";
    ui_font_size = 16;

    buffer_font_family = "Cascadia Code";
    buffer_font_Size = 16;

    ##
    ## Navigation
    ##

    vim_mode = true;
    relative_line_numbers = true;
    seed_search_query_from_cursor = "selection";

    ##
    ## Editor Visuals
    ##

    cursor_blink = false;
    wrap_guides = [ 80 90 ];

    tab_bar.show_nav_history_buttons = false;
    tabs.git_status = true;
    project_panel.dock = "right";
    git.inline_blame.delay_ms = 2000;

    inlay_hints = {
      enabled = true;
      show_type_hints = true;
      show_parameter_hints = true;
      show_other_hints = true;
      edit_debounce_ms = 700;
      scroll_debounce_ms = 50;
    };

    ##
    ## Formatting
    ##

    format_on_save = "on";
    formatter = "language_server";
    use_on_type_format = false;
    preferred_line_length = 90;

    ##
    ## Terminal
    ##

    terminal = {
      working_directory = "first_project_directory";

      font_size = 16;
      font_family = "CaskaydiaCove Nerd Font Mono";
    };

    ##
    ## Tweaks
    ##

    auto_update = false;
    assistant.enabled = false;
    preview_tabs.enabled = false;
    telemetry.metrics = false;

    file_types = {
      "JSON" = [ "Cargo.lock" ];
    };

    languages = {
      "C".language_servers = [ "clangd" ];
      "C++".language_servers = [ "clangd" ];
      "Rust".language_servers = [ "rust-analyzer" ];
      "Nix".language_servers = [ "nixd" ];
      "JSON".language_servers = [ ];
    };

    lsp = {
      clangd = {
        binary.path = "${pkgs.llvmPackages.clang-tools}/bin/clangd";
      };

      rust-analyzer = {
        binary.path = "${pkgs.rustup}/bin/rust-analyzer";

        initialization_options = {
          check.command = "clippy";
          completion.fullFunctionSignatures.enable = true;
          hover.actions.run.enable = false;
          hover.memoryLayout.niches = true;

          inlayHints.maxLength = null;
          inlayHints.lifetimeElisionHints = {
            enable = "skip_trivial";
            useParameterNames = true;
          };
          inlayHints.closureReturnTypeHints.enable = "always";
          inlayHints.parameterHints.enable = false;
        };
      };

      nixd = {
        binary.path = "${pkgs.nixd}/bin/nixd";
      };
    };
  };

  home.packages = [
    pkgs.nerd-fonts.caskaydia-cove
  ];
}
