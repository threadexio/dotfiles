{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      format = lib.concatStrings [
        " "
        "$nix_shell"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_commit"
        "$git_status"
        "[»](red bold) "
      ];

      nix_shell = {
        heuristic = true;
      };

      git_branch = {
        symbol = " ";
        truncation_length = 5;
        truncation_symbol = "…";
        ignore_branches = [ "master" "main" ];
        format = lib.concatStrings [
          "on ["
          "$symbol"
          "$branch"
          "](yellow) "
        ];
      };

      git_commit = {
        commit_hash_length = 7;
        only_detached = true;
        tag_max_candidates = 1;
        tag_disabled = false;
        tag_symbol = " 🏷  ";
        format = lib.concatStrings [
          "["
          "$hash"
          "$tag"
          "](bold green) "
        ];
      };

      git_status = {
        style = "green underline";
        format = lib.concatStrings [
          "(["
          "$all_status"
          "$ahead_behind"
          "]($style)) "
        ];
      };
    };
  };

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = true;

    shellAliases = {
      ls = "lsd -h --color=auto";
      l = "lsd -lAFh --color=auto";
      la = "lsd -ha --color=auto";
      ll = "lsd -hl --color=auto";


      cp = "rsync -pogbr -hhh -e /dev/null --progress";
      rm = "rm -i";

      cat = "bat";
      grep = "rg";
      g = "grep";

      c = "clear";
      ip = "ip --color=always";

      chmod = "chmod --verbose";
      chown = "chown --verbose";
    };

    envExtra = lib.concatLines [
      "export GPG_TTY=$(tty)"
      "export PATH=\"$HOME/.bin:$PATH\""
      "export EDITOR=vim"
    ];

    history = {
      extended = true;
      path = "$ZDOTDIR/.history";
      share = false;
    };

    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "NhOEHgwInvR62XyyHXo7eWtcsky9mTisf9JjPwllZ78=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0-alpha1-pre-redrawhook";
          sha256 = "NhOEHgwInvR62XyyHXo7eWtcsky9mTisf9JjPwllZ78=";
        };
      }
      {
        name = "colored-man-pages";
        src = builtins.toFile "colored-man-pages.plugin.zsh" ''
          # termcap
          # ks       make the keypad send commands
          # ke       make the keypad send digits
          # vb       emit visual bell
          # mb       start blink
          # md       start bold
          # me       turn off bold, blink and underline
          # so       start standout (reverse video)
          # se       stop standout
          # us       start underline
          # ue       stop underline

          function man() {
                  env \
                          LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
                          LESS_TERMCAP_me=$(tput sgr0) \
                          LESS_TERMCAP_mb=$(tput blink) \
                          LESS_TERMCAP_us=$(tput setaf 2) \
                          LESS_TERMCAP_ue=$(tput sgr0) \
                          LESS_TERMCAP_so=$(tput smso) \
                          LESS_TERMCAP_se=$(tput rmso) \
                          PAGER=\"$${commands[less]:-$PAGER}\" \
                          man "$@"
          }
        '';
      }
    ];

    syntaxHighlighting.enable = true;
  };

  home.packages = [
    pkgs.lsd
    pkgs.bat
    pkgs.ripgrep
    pkgs.rsync
  ];
}
