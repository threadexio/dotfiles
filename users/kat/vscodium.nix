{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium-fhs;

    enableUpdateCheck = false;
    extensions = with pkgs.vscode-extensions; [
      # General
      alefragnani.bookmarks
      editorconfig.editorconfig
      gruntfuggly.todo-tree
      ms-vscode.hexeditor
      streetsidesoftware.code-spell-checker
      usernamehw.errorlens

      # Theming
      equinusocio.vsc-material-theme
      oderwat.indent-rainbow
      pkief.material-icon-theme

      # Markdown
      bierner.emojisense
      bierner.markdown-mermaid
      davidanson.vscode-markdownlint
      yzhang.markdown-all-in-one

      # C/C++
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      twxs.cmake
      xaver.clang-format

      # Nix
      jnoortheen.nix-ide

      # Python
      ms-python.black-formatter
      ms-python.python

      # Rust
      rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml
      vadimcn.vscode-lldb
    ];
    mutableExtensionsDir = true;

    keybindings = [
      { command = "workbench.action.terminal.focus"; key = "ctrl+alt+t"; }
      { command = "-code-runner.runByLanguage"; key = "ctrl+alt+j"; }
      { command = "-problems.action.showQuickFixes"; key = "ctrl+."; when = "problemFocus"; }
      { command = "-settings.action.editFocusedSetting"; key = "ctrl+."; when = "inSettingsSearch"; }
      { command = "-editor.action.quickFix"; key = "ctrl+."; when = "editorHasCodeActionsProvider && editorTextFocus && !editorReadonly"; }
      { command = "-workbench.action.terminal.split"; key = "ctrl+shift+5"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "workbench.action.splitEditorRight"; key = "ctrl+/ right"; }
      { command = "workbench.action.splitEditorLeft"; key = "ctrl+/ left"; }
      { command = "workbench.action.splitEditorDown"; key = "ctrl+/ down"; }
      { command = "workbench.action.splitEditorUp"; key = "ctrl+/ up"; }
      { command = "workbench.action.focusAboveGroup"; key = "ctrl+alt+up"; }
      { command = "-workbench.action.focusAboveGroup"; key = "ctrl+k ctrl+up"; }
      { command = "workbench.action.focusBelowGroup"; key = "ctrl+alt+down"; }
      { command = "-workbench.action.focusBelowGroup"; key = "ctrl+k ctrl+down"; }
      { command = "workbench.action.focusLeftGroup"; key = "ctrl+alt+left"; }
      { command = "-workbench.action.focusLeftGroup"; key = "ctrl+k ctrl+left"; }
      { command = "workbench.action.focusRightGroup"; key = "ctrl+alt+right"; }
      { command = "-workbench.action.focusRightGroup"; key = "ctrl+k ctrl+right"; }
      { command = "-workbench.action.closeWindow"; key = "ctrl+shift+w"; }
      { command = "-workbench.action.terminal.openNativeConsole"; key = "ctrl+shift+c"; when = "!terminalFocus"; }
      { command = "-workbench.action.splitEditor"; key = "ctrl+\\"; }
      { command = "editor.action.inPlaceReplace.up"; key = "ctrl+alt+,"; when = "editorTextFocus && !editorReadonly"; }
      { command = "-editor.action.inPlaceReplace.up"; key = "ctrl+shift+,"; when = "editorTextFocus && !editorReadonly"; }
      { command = "workbench.action.openSettings"; key = "ctrl+."; }
      { command = "-workbench.action.openSettings"; key = "ctrl+,"; }
      { command = "workbench.panel.repl.view.focus"; key = "ctrl+shift+d"; }
      { command = "-expandLineSelection"; key = "ctrl+l"; when = "textInputFocus"; }
      { command = "workbench.action.terminal.clear"; key = "ctrl+l"; }
      { command = "workbench.action.terminal.paste"; key = "ctrl+v"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "-workbench.action.terminal.paste"; key = "ctrl+shift+v"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "workbench.action.quickOpenTerm"; key = "ctrl+alt+s"; }
      { command = "-workbench.action.moveEditorRightInGroup"; key = "ctrl+shift+pagedown"; }
      { command = "workbench.action.terminal.resizePaneDown"; key = "ctrl+shift+down"; }
      { command = "workbench.action.terminal.scrollDown"; key = "ctrl+shift+pagedown"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "-workbench.action.terminal.scrollDown"; key = "ctrl+shift+down"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "-editor.action.insertCursorBelow"; key = "ctrl+shift+down"; when = "editorTextFocus"; }
      { command = "workbench.action.terminal.resizePaneUp"; key = "ctrl+shift+up"; }
      { command = "workbench.action.terminal.scrollUp"; key = "ctrl+shift+pageup"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "-workbench.action.terminal.scrollUp"; key = "ctrl+shift+up"; when = "terminalFocus && terminalProcessSupported"; }
      { command = "-editor.action.insertCursorAbove"; key = "ctrl+shift+up"; when = "editorTextFocus"; }
      { command = "-workbench.action.moveEditorLeftInGroup"; key = "ctrl+shift+pageup"; }
      { command = "-workbench.view.debug"; key = "ctrl+shift+d"; when = "viewContainer.workbench.view.debug.enabled"; }
      { command = "-notebook.cell.split"; key = "ctrl+shift+-"; when = "config.jupyter.enableKeyboardShortcuts && editorTextFocus && inputFocus && notebookEditorFocused && notebookViewType == 'jupyter-notebook'"; }
      { command = "-notebook.cell.split"; key = "ctrl+k ctrl+shift+\\"; when = "notebookCellEditable && notebookEditable && notebookEditorFocused"; }
      { command = "workbench.action.terminal.split"; key = "ctrl+shift+/"; }
      { command = "-problems.action.copy"; key = "ctrl+c"; when = "problemFocus"; }
      { command = "workbench.debug.panel.action.clearReplAction"; key = "ctrl+l"; }
      { command = "-liveshare.follow"; key = "ctrl+alt+f"; when = "liveshare:hasCollaborators && !liveshare:isFollowing"; }
      { command = "-liveshare.unfollow"; key = "ctrl+alt+f"; when = "liveshare:hasCollaborators && liveshare:isFollowing"; }
      { command = "workbench.panel.markers.view.focus"; key = "ctrl+alt+p"; }
      { command = "-workbench.action.quit"; key = "ctrl+q"; }
      { command = "workbench.action.toggleMaximizedPanel"; key = "ctrl+alt+z"; }
      { command = "-markdown.extension.onCopyLineUp"; key = "shift+alt+up"; when = "editorTextFocus && !editorReadonly && !suggestWidgetVisible && editorLangId == 'markdown'"; }
      { command = "-markdown.extension.onCopyLineDown"; key = "shift+alt+down"; when = "editorTextFocus && !editorReadonly && !suggestWidgetVisible && editorLangId == 'markdown'"; }
      { command = "-breadcrumbs.focusAndSelect"; key = "ctrl+shift+."; when = "breadcrumbsPossible"; }
      { command = "-breadcrumbs.toggleToOn"; key = "ctrl+shift+."; when = "!config.breadcrumbs.enabled"; }
      { command = "editor.action.copyLinesUpAction"; key = "ctrl+up"; when = "editorTextFocus && !editorReadonly"; }
      { command = "-editor.action.copyLinesUpAction"; key = "ctrl+shift+alt+up"; when = "editorTextFocus && !editorReadonly"; }
      { command = "editor.action.copyLinesDownAction"; key = "ctrl+down"; when = "editorTextFocus && !editorReadonly"; }
      { command = "-editor.action.copyLinesDownAction"; key = "ctrl+shift+alt+down"; when = "editorTextFocus && !editorReadonly"; }
    ];

    userSettings = {
      "[c]" = { "editor.defaultFormatter" = "xaver.clang-format"; };
      "[cpp]" = { "editor.defaultFormatter" = "xaver.clang-format"; };
      "[json]" = { "editor.defaultFormatter" = "vscode.json-language-features"; };
      "[jsonc]" = { "editor.defaultFormatter" = "vscode.json-language-features"; };
      "[markdown]" = { "editor.defaultFormatter" = "yzhang.markdown-all-in-one"; "editor.detectIndentation" = false; "editor.insertSpaces" = true; "editor.tabSize" = 2; };
      "[nix]" = { "editor.defaultFormatter" = "jnoortheen.nix-ide"; "editor.insertSpaces" = true; "editor.tabSize" = 2; };
      "[rust]" = { "editor.defaultFormatter" = "rust-lang.rust-analyzer"; };
      "cmake.configureOnOpen" = false;
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.acceptSuggestionOnEnter" = "off";
      "editor.accessibilitySupport" = "off";
      "editor.bracketPairColorization.enabled" = true;
      "editor.bracketPairColorization.independentColorPoolPerBracketType" = true;
      "editor.comments.ignoreEmptyLines" = false;
      "editor.cursorBlinking" = "smooth";
      "editor.cursorSmoothCaretAnimation" = "on";
      "editor.cursorStyle" = "line-thin";
      "editor.emptySelectionClipboard" = false;
      "editor.find.autoFindInSelection" = "multiline";
      "editor.fontFamily" = "CaskaydiaCove Nerd Font Mono";
      "editor.fontLigatures" = true;
      "editor.formatOnSave" = true;
      "editor.hover.delay" = 150;
      "editor.inlineSuggest.showToolbar" = "always";
      "editor.insertSpaces" = false;
      "editor.lightbulb.enabled" = false;
      "editor.lineNumbers" = "relative";
      "editor.linkedEditing" = true;
      "editor.minimap.size" = "fill";
      "editor.mouseWheelZoom" = true;
      "editor.padding.bottom" = 20;
      "editor.padding.top" = 20;
      "editor.quickSuggestions" = { comments = "off"; other = "off"; strings = "off"; };
      "editor.renderLineHighlight" = "gutter";
      "editor.scrollBeyondLastColumn" = 0;
      "editor.scrollbar.horizontalScrollbarSize" = 6;
      "editor.scrollbar.vertical" = "hidden";
      "editor.smoothScrolling" = true;
      "editor.snippetSuggestions" = "bottom";
      "editor.stickyTabStops" = true;
      "editor.suggest.preview" = true;
      "editor.tabCompletion" = "on";
      "editor.wordSeparators" = "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?";
      "explorer.compactFolders" = false;
      "explorer.confirmDelete" = false;
      "extensions.autoUpdate" = "onlyEnabledExtensions";
      "extensions.ignoreRecommendations" = true;
      "files.hotExit" = "off";
      "files.insertFinalNewline" = true;
      "files.simpleDialog.enable" = true;
      "files.trimTrailingWhitespace" = true;
      "git.allowNoVerifyCommit" = true;
      "git.alwaysShowStagedChangesResourceGroup" = true;
      "git.alwaysSignOff" = true;
      "git.branchProtection" = [ "master" ];
      "git.enableCommitSigning" = true;
      "git.openRepositoryInParentFolders" = "never";
      "github.gitAuthentication" = false;
      "hediet.vscode-drawio.codeLinkActivated" = false;
      "hediet.vscode-drawio.resizeImages" = null;
      "lldb.suppressUpdateNotifications" = true;
      "markdown.extension.preview.autoShowPreviewToSide" = true;
      "markdown.extension.syntax.plainTheme" = true;
      "markdown.extension.tableFormatter.delimiterRowNoPadding" = true;
      "markdown.extension.tableFormatter.normalizeIndentation" = true;
      "markdown.extension.theming.decoration.renderParagraph" = true;
      "markdown.extension.toc.orderedList" = false;
      "markdown.extension.toc.slugifyMode" = "github";
      "markdown.extension.toc.unorderedList.marker" = "*";
      "markdown.extension.toc.updateOnSave" = false;
      "markdownlint.config" = { first-line-h1 = false; no-inline-html = false; };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "problems.sortOrder" = "position";
      "rust-analyzer.check.command" = "clippy";
      "rust-analyzer.checkOnSave" = true;
      "rust-analyzer.debug.engine" = "vadimcn.vscode-lldb";
      "rust-analyzer.diagnostics.useRustcErrorCode" = true;
      "rust-analyzer.inlayHints.chainingHints.enable" = false;
      "rust-analyzer.inlayHints.closureReturnTypeHints.enable" = "with_block";
      "rust-analyzer.inlayHints.parameterHints.enable" = false;
      "rust-analyzer.restartServerOnConfigChange" = true;
      "security.workspace.trust.untrustedFiles" = "open";
      "telemetry.telemetryLevel" = "off";
      "terminal.integrated.enableFileLinks" = "off";
      "terminal.integrated.enableMultiLinePasteWarning" = false;
      "terminal.integrated.enablePersistentSessions" = false;
      "update.mode" = "none";
      "window.commandCenter" = true;
      "window.dialogStyle" = "custom";
      "window.menuBarVisibility" = "compact";
      "window.restoreWindows" = "none";
      "window.titleBarStyle" = "custom";
      "workbench.commandPalette.history" = 5;
      "workbench.editor.untitled.hint" = "hidden";
      "workbench.enableExperiments" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.list.smoothScrolling" = true;
      "workbench.panel.opensMaximized" = "never";
      "workbench.sideBar.location" = "right";
    };
  };

  home.packages = [ pkgs.nerdfonts ];
}
