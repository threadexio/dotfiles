{ ... }:

[
  {
    context = "Editor";
    bindings = {
      "ctrl-space" = "editor::ShowCompletions";
      "ctrl-x" = "editor::ToggleCodeActions";
    };
  }
  {
    context = "Editor && (vim_mode == normal || vim_mode == visual)";
    bindings = {
      ##
      ## Changes
      ## 

      "r" = "vim::ToggleReplace";
      "R" = "vim::ToggleReplace";
      "~" = "vim::ChangeCase";
      "`" = "vim::ConvertToLowerCase";
      "alt-`" = "vim::ConvertToUpperCase";
      "i" = "vim::InsertBefore";
      "a" = "vim::InsertAfter";
      # Insert at start of line.
      "A" = "vim::InsertEndOfLine";
      "o" = "vim::InsertLineBelow";
      "O" = "vim::InsertLineAbove";
      "u" = "vim::Undo";
      "U" = "vim::Redo";
      "y" = "vim::Yank";
      "=" = "editor::FormatSelections";
      "d" = "vim::DeleteRight";
      "alt-d" = "editor::Delete";
      "Q" = "vim::ToggleRecord";
      "q" = "vim::ReplayLastRecording";

      ##
      ## Selection manipulation
      ##

      "s" = "vim::Search";
      "ctrl-s" = "search::SelectAllMatches";
      # Split selection into sub selections on regex matches.
      "alt-s" = "editor::SplitSelectionIntoLines";
      # Merge selections.
      # Merge consecutive selections.
      # Align selection in columns.
      # Trim whitespace from the selection.
      ";" = "editor::Cancel";
      # Flip selection cursor and anchor.
      # Ensures the selection is in forward direction.
      # Keep only the primary selection.
      # Remove the primary selection.
      "C" = "editor::AddSelectionBelow";
      "alt-C" = "editor::AddSelectionAbove";
      # Rotate main selection backward.
      # Rotate main selection forward.
      # Rotate selection contents backward.
      # Rotate selection contents forward.
      "%" = "editor::SelectAll";
      "x" = "editor::SelectLine";
      # Extend selection to line bounds.
      # Shrink selection to line bounds.
      "J" = "editor::JoinLines";
      "alt-J" = "vim::JoinLinesNoWhitespace";
      # Keep selections matching the regex.
      # Remove selections matching the regex.
      "ctrl-c" = "editor::ToggleComments";

      #
      # Search
      #

      "/" = "vim::Search";
      # Search for previous pattern.
      "n" = "search::SelectNextMatch";
      "N" = "search::SelectPrevMatch";
      # Use current selection as the search pattern. (with word boundaries)
      # Use current selection as the search pattern.

      ##
      ## Space Mode
      ##

      "space f" = "file_finder::Toggle";
      "space F" = "file_finder::Toggle";
      "space b" = "file_finder::Toggle";
      "space j" = "file_finder::Toggle";
      "space s" = "outline::Toggle";
      "space S" = "project_symbols::Toggle";
      "space d" = "diagnostics::Deploy";
      "space D" = "diagnostics::Deploy";
      # Open changed file picker
      "space a" = "editor::ToggleCodeActions";
      # Open last picker.
      "space w s" = "pane::SplitDown";
      "space w v" = "pane::SplitRight";
      "space w q" = "pane::CloseActiveItem";
      "space w H" = "pane::SwapItemLeft";
      "space w L" = "pane::SwapItemRight";
      "space w n" = "workspace::NewFile";
      "space y" = "vim::Yank";
      "space Y" = "vim::VisualYank";
      "space /" = "pane::DeploySearch";
      # Show docs for item under cursor.
      "space r" = "editor::Rename";
      "space c" = "editor::ToggleComments";
      "space C" = "editor::ToggleComments";

      ##
      ## Goto Mode
      ##

      "G" = "go_to_line::Toggle";
      "g g" = "vim::StartOfDocument";
      "g e" = "vim::EndOfDocument";
      "g h" = "editor::MoveToBeginningOfLine";
      "g l" = "editor::MoveToEndOfLine";
      "g d" = "editor::GoToDefinition";
      "g D" = "editor::GoToDeclaration";
      "g y" = "editor::GoToTypeDefinition";
      "g r" = "editor::FindAllReferences";
      "g i" = "editor::GoToImplementation";
      "g n" = "pane::ActivateNextItem";
      "g p" = "pane::ActivatePrevItem";
    };
  }
]
