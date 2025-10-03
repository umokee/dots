{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;

    profiles.default = {
      userSettings = {
        "editor.fontFamily" = "'Jetbrains Mono', 'bold', bold";
        "editor.fontSize" = 18;
        "window.zoomLevel" = 1;

        "workbench.iconTheme" = "bearded-icons";
        "workbench.colorTheme" = "Tokyo Night Matugen";

        "editor.formatOnSave" = true;
        "editor.formatOnPaste" = true;
        "editor.codeActionsOnSave" = {
          "source.fixAll.eslint" = "explicit";
          "source.organizeImports" = "explicit";
        };

        "errorLens.enabled" = true;
        "errorLens.enabledDiagnosticLevels" = [
          "error"
          "warning"
          "info"
          "hint"
        ];
        "errorLens.fontSize" = "14";
        "errorLens.fontStyleItalic" = true;
        "errorLens.gutterIconsEnabled" = true;
        "errorLens.messageTemplate" = "$message";
        "errorLens.delay" = 0;

        "problems.showCurrentInStatus" = true;
        "problems.sortOrder" = "severity";

        "editor.tabSize" = 2;
        "editor.detectIndentation" = false;
        "editor.lineNumbers" = "relative";
        "workbench.tree.indent" = 14;
        "files.insertFinalNewline" = true;

        "workbench.sideBar.location" = "left";
        "workbench.statusBar.visible" = false;
        "workbench.activityBar.location" = "hidden";
        "workbench.editor.showTabs" = "single";
        "workbench.startupEditor" = "none";
        "chat.commandCenter.enabled" = false;
        "workbench.layoutControl.enabled" = false;
        "window.customTitleBarVisibility" = "never";
        "window.titleBarStyle" = "native";
        "window.menuBarVisibility" = "toggle";

        "editor.scrollbar.horizontal" = "hidden";
        "editor.scrollbar.vertical" = "hidden";
        "editor.minimap.enabled" = false;

        "editor.multiCursorModifier" = "ctrlCmd";
        "editor.cursorBlinking" = "solid";
        "editor.matchBrackets" = "never";
        "editor.occurrencesHighlight" = "off";
        
        "editor.bracketPairColorization.enabled" = true;
        "editor.guides.bracketPairs" = true;
        #"editor.guides.bracketPairsHorizontal" = true;
        #"editor.guides.highlightActiveIndentation" = true;

        "editor.lightbulb.enabled" = "off";
        "editor.showFoldingControls" = "never";
        "breadcrumbs.enabled" = false;
        "workbench.tips.enabled" = false;

        "editor.overviewRulerBorder" = false;
        "editor.hideCursorInOverviewRuler" = true;

        "editor.stickyScroll.enabled" = false;
        "workbench.tree.enableStickyScroll" = false;

        "explorer.confirmDragAndDrop" = true;
        "explorer.confirmDelete" = true;
        "explorer.decorations.badges" = false;
        "workbench.tree.renderIndentGuides" = "none";

        "git.decorations.enabled" = false;
        "scm.diffDecorations" = "none";

        "files.autoSave" = "afterDelay";

        "extensions.ignoreRecommendations" = true;
      };
      keybindings = [
        {
          key = "alt+e";
          command = "workbench.view.explorer";
        }
        {
          key = "alt+g";
          command = "workbench.view.scm";
        }
        {
          key = "alt+x";
          command = "workbench.view.extensions";
        }
        {
          key = "alt+t";
          command = "workbench.action.terminal.toggleTerminal";
        }

        # ===== ДОПОЛНИТЕЛЬНЫЕ ПОЛЕЗНЫЕ БИНДИНГИ =====

        # Debug панель
        {
          key = "ctrl+5";
          command = "workbench.view.debug";
        }
        # Search панель
        {
          key = "ctrl+6";
          command = "workbench.view.search";
        }

        # Скрыть/показать боковую панель
        {
          key = "ctrl+b";
          command = "workbench.action.toggleSidebarVisibility";
        }

        # Скрыть/показать панель (где терминал)
        {
          key = "ctrl+j";
          command = "workbench.action.togglePanel";
        }
      ];
    };
  };

  home.file = {
    ".vscode/extensions/tokyo-night-matugen/package.json" = {
      text = builtins.toJSON {
        name = "tokyo-night-matugen";
        displayName = "Tokyo Night Matugen";
        description = "Tokyo Night theme with Matugen dynamic colors";
        version = "1.0.0";
        engines.vscode = "^1.74.0";
        categories = [
          "Themes"
        ];
        contributes.themes = [{
          label = "Tokyo Night Matugen";
          uiTheme = "vs-dark";
          path = "./themes/tokyo-night-matugen.json";
        }];
      };
    };

    ".vscode/extensions/tokyo-night-matugen/themes/.gitkeep".text = "";
  };
}
