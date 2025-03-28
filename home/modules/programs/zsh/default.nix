{ config
, pkgs
, lib
, ...
}: {
  home.shell.enableZshIntegration = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
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
      "export EDITOR=hx"
    ];

    history = {
      extended = true;
      path = "${config.xdg.cacheHome}/zsh/history";
      share = false;
    };

    historySubstringSearch.enable = true;

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.1";
          sha256 = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "v1.2.0";
          sha256 = "sha256-q26XVS/LcyZPRqDNwKKA9exgBByE0muyuNb0Bbar2lY=";
        };
      }
      {
        name = "colored-man-pages";
        src = ./colored-man-pages.plugin.zsh;
      }
    ];

    syntaxHighlighting.enable = true;

    initExtra = ''
      bindkey "^[[H"     beginning-of-line
      bindkey "^[[F"     end-of-line
      bindkey "^[[3~"    delete-char
      bindkey "^[[1;5D"  backward-word
      bindkey "^[[1;5C"  forward-word

      bindkey "^H" backward-delete-word
      bindkey "^[[3;5~" delete-word
    '';
  };

  programs.tmux = {
    shell = "${pkgs.zsh}/bin/zsh";
  };

  home.packages = with pkgs; [
    lsd
    bat
    ripgrep
    rsync
    file
    neofetch
  ];
}
