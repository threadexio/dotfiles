{ pkgs, ... }: {
  imports = [./module.nix];

  custom.programs.zed = {
    enable = true;

    settings = {
        theme = "Ayu Dark";
        base_keymap = "VSCode";

        /*
         * ==== Fonts ====
         */

        ui_font_family = "Noto Sans";
        ui_font_size = 16;

        buffer_font_family = "CaskaydiaCove Nerd Font Mono";
        buffer_font_Size = 16;

        /*
         * ==== Navigation ====
         */

        vim_mode = true;
        relative_line_numbers = true;
        seed_search_query_from_cursor = "selection";

        /*
         * ==== Editor Visuals ====
         */

        cursor_blink = false;
        wrap_guides = [ 80 90 ];

        tab_bar.show_nav_history_buttons = false;
        tabs.git_status = true;
        project_panel.dock = "right";
        git.inline_blame.delay_ms = 2000;

        /*
         * ==== Formatting ====
         */

        format_on_save = "on";
        formatter = "language_server";
        use_on_type_format = false;
        preferred_line_length = 90;

        /*
         * ==== Terminal ====
         */

        terminal = {
            working_directory = "first_project_directory";

            font_size = 16;
            font_family = "CaskaydiaCove Nerd Font Mono";
        };

        /*
         * ==== Tweaks ====
         */

        auto_update = false;
        assistant.enabled = false;
        preview_tabs.enabled = false;
        telemetry.metrics = false;

        file_types = {
            "JSON" = [ "Cargo.lock" ];
        };

        languages = {
            "C".language_servers = ["clangd"];
            "C++".language_servers = ["clangd"];
            "Rust".language_servers = ["rust-analyzer"];
            "JSON".language_servers = [];
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
              };
            };

            nixd = {
                binary.path = "${pkgs.nixd}/bin/nixd";
            };
        };
    };
  };

  home.packages = with pkgs; [
      llvmPackages.clang-tools
      nixd
  ];
}
