{
  config,
  lib,
  vars,
  ...
}:
let
  enable = lib.elem "matugen" (vars.desktop.enable or [ ]);
in
{
  config = lib.mkIf enable {
    home.file = {
      ".config/matugen/templates/vscode.json".text = ''
        {
          "name": "Tokyo Night Matugen",
          "type": "vs-dark",
          "colors": {
            "editor.background": "{{colors.background.default.hex}}",
            "editor.foreground": "{{colors.on_background.default.hex}}",
            "activityBar.background": "{{colors.surface.default.hex}}",
            "activityBar.foreground": "{{colors.on_surface.default.hex}}",
            "activityBar.inactiveForeground": "{{colors.outline.default.hex}}",
            "activityBarBadge.background": "{{colors.primary.default.hex}}",
            "activityBarBadge.foreground": "{{colors.on_primary.default.hex}}",
            "badge.background": "{{colors.primary.default.hex}}",
            "badge.foreground": "{{colors.on_primary.default.hex}}",
            "button.background": "{{colors.primary.default.hex}}",
            "button.foreground": "{{colors.on_primary.default.hex}}",
            "button.hoverBackground": "{{colors.primary_container.default.hex}}",
            "dropdown.background": "{{colors.surface.default.hex}}",
            "dropdown.foreground": "{{colors.on_surface.default.hex}}",
            "editor.lineHighlightBackground": "{{colors.surface_variant.default.hex}}40",
            "editor.selectionBackground": "{{colors.primary.default.hex}}40",
            "editor.wordHighlightBackground": "{{colors.secondary.default.hex}}40",
            "editorCursor.foreground": "{{colors.primary.default.hex}}",
            "editorGroup.border": "{{colors.outline.default.hex}}",
            "editorGroupHeader.tabsBackground": "{{colors.background.default.hex}}",
            "editorIndentGuide.background": "{{colors.outline.default.hex}}40",
            "editorLineNumber.foreground": "{{colors.outline.default.hex}}",
            "editorLineNumber.activeForeground": "{{colors.primary.default.hex}}",

            "editorBracketMatch.background": "{{colors.primary.default.hex}}40",
            "editorBracketMatch.border": "{{colors.primary.default.hex}}",
            "editorBracketHighlight.foreground1": "{{colors.primary.default.hex}}",
            "editorBracketHighlight.foreground2": "{{colors.secondary.default.hex}}",
            "editorBracketHighlight.foreground3": "{{colors.tertiary.default.hex}}",
            "editorBracketHighlight.foreground4": "{{colors.primary_container.default.hex}}",
            "editorBracketHighlight.foreground5": "{{colors.secondary_container.default.hex}}",
            "editorBracketHighlight.foreground6": "{{colors.tertiary_container.default.hex}}",
            "editorBracketHighlight.unexpectedBracket.foreground": "{{colors.error.default.hex}}",
            "editorBracketPairGuide.background1": "{{colors.primary.default.hex}}30",
            "editorBracketPairGuide.background2": "{{colors.secondary.default.hex}}30", 
            "editorBracketPairGuide.background3": "{{colors.tertiary.default.hex}}30",
            "editorBracketPairGuide.background4": "{{colors.primary_container.default.hex}}30",
            "editorBracketPairGuide.background5": "{{colors.secondary_container.default.hex}}30",
            "editorBracketPairGuide.background6": "{{colors.tertiary_container.default.hex}}30",
            "editorBracketPairGuide.activeBackground1": "{{colors.primary.default.hex}}50",
            "editorBracketPairGuide.activeBackground2": "{{colors.secondary.default.hex}}50",
            "editorBracketPairGuide.activeBackground3": "{{colors.tertiary.default.hex}}50",
            "editorBracketPairGuide.activeBackground4": "{{colors.primary_container.default.hex}}50",
            "editorBracketPairGuide.activeBackground5": "{{colors.secondary_container.default.hex}}50",
            "editorBracketPairGuide.activeBackground6": "{{colors.tertiary_container.default.hex}}50",

            "focusBorder": "{{colors.primary.default.hex}}",
            "list.activeSelectionBackground": "{{colors.primary.default.hex}}40",
            
            "list.activeSelectionForeground": "{{colors.on_surface.default.hex}}",
            "list.hoverBackground": "{{colors.surface_variant.default.hex}}40",
            "list.hoverForeground": "{{colors.on_surface_variant.default.hex}}",
            "list.inactiveSelectionBackground": "{{colors.surface_variant.default.hex}}40",
            "panel.background": "{{colors.surface.default.hex}}",
            "panel.border": "{{colors.outline.default.hex}}",
            "panelTitle.activeForeground": "{{colors.primary.default.hex}}",
            "peekView.border": "{{colors.primary.default.hex}}",
            "peekViewEditor.background": "{{colors.surface.default.hex}}",
            "peekViewResult.background": "{{colors.surface_variant.default.hex}}",
            "peekViewTitle.background": "{{colors.surface.default.hex}}",
            "progressBar.background": "{{colors.primary.default.hex}}",
            "scrollbar.shadow": "{{colors.background.default.hex}}00",
            "scrollbarSlider.activeBackground": "{{colors.primary.default.hex}}80",
            "scrollbarSlider.background": "{{colors.surface_variant.default.hex}}40",
            "scrollbarSlider.hoverBackground": "{{colors.surface_variant.default.hex}}80",
            "sideBar.background": "{{colors.surface.default.hex}}",
            "sideBar.foreground": "{{colors.on_surface.default.hex}}",
            "sideBarSectionHeader.background": "{{colors.surface_variant.default.hex}}",
            "sideBarSectionHeader.foreground": "{{colors.on_surface_variant.default.hex}}",
            "sideBarTitle.foreground": "{{colors.primary.default.hex}}",
            "statusBar.background": "{{colors.surface_variant.default.hex}}",
            "statusBar.foreground": "{{colors.on_surface_variant.default.hex}}",
            "statusBar.debuggingBackground": "{{colors.tertiary.default.hex}}",
            "statusBar.debuggingForeground": "{{colors.on_tertiary.default.hex}}",
            "statusBar.noFolderBackground": "{{colors.surface.default.hex}}",
            "statusBarItem.remoteBackground": "{{colors.primary.default.hex}}",
            "statusBarItem.remoteForeground": "{{colors.on_primary.default.hex}}",
            "tab.activeBackground": "{{colors.surface.default.hex}}",
            "tab.activeForeground": "{{colors.primary.default.hex}}",
            "tab.inactiveBackground": "{{colors.background.default.hex}}",
            "tab.inactiveForeground": "{{colors.outline.default.hex}}",
            "terminal.background": "{{colors.background.default.hex}}",
            "terminal.foreground": "{{colors.on_background.default.hex}}",
            "titleBar.activeBackground": "{{colors.surface.default.hex}}",
            "titleBar.activeForeground": "{{colors.on_surface.default.hex}}",
            "titleBar.inactiveBackground": "{{colors.surface_variant.default.hex}}",
            "titleBar.inactiveForeground": "{{colors.on_surface_variant.default.hex}}"
          },
          "tokenColors": [
            {
              "scope": ["comment", "punctuation.definition.comment", "string.comment"],
              "settings": {
                "foreground": "{{colors.outline.default.hex}}"
              }
            },
            {
              "scope": ["constant", "entity.name.constant", "variable.other.constant", "variable.other.enummember"],
              "settings": {
                "foreground": "{{colors.primary.default.hex}}"
              }
            },
            {
              "scope": ["entity.name", "entity.other.attribute-name"],
              "settings": {
                "foreground": "{{colors.tertiary.default.hex}}"
              }
            },
            {
              "scope": ["entity.name.tag", "keyword", "storage.type", "storage.modifier"],
              "settings": {
                "foreground": "{{colors.primary.default.hex}}"
              }
            },
            {
              "scope": ["string", "string punctuation.section.embedded source"],
              "settings": {
                "foreground": "{{colors.secondary.default.hex}}"
              }
            },
            {
              "scope": ["variable", "variable.parameter.function"],
              "settings": {
                "foreground": "{{colors.on_background.default.hex}}"
              }
            },
            {
              "scope": ["support.function", "entity.name.function"],
              "settings": {
                "foreground": "{{colors.tertiary.default.hex}}"
              }
            },
            {
              "name": "Punctuation",
              "scope": [
                "punctuation.definition.block",
                "punctuation.definition.array", 
                "punctuation.definition.parameters",
                "punctuation.section.scope",
                "punctuation.definition.dictionary",
                "punctuation.definition.arguments",
                "punctuation.definition.function",
                "punctuation.section.brackets",
                "punctuation.section.parens",
                "punctuation.section.braces",
                "meta.brace",
                "meta.bracket"
              ],
              "settings": {
                "foreground": "{{colors.primary.default.hex}}"
              }
            },
            {
              "name": "Brackets Level 1",
              "scope": ["punctuation.definition.block", "punctuation.definition.array", "punctuation.definition.parameters", "punctuation.section.scope"],
              "settings": {
                "foreground": "{{colors.primary.default.hex}}"
              }
            },
            {
              "name": "Brackets Level 2",
              "scope": ["punctuation.definition.dictionary", "punctuation.definition.string"],
              "settings": {
                "foreground": "{{colors.secondary.default.hex}}"
              }
            },
            {
              "name": "Brackets Level 3",
              "scope": ["punctuation.definition.arguments", "punctuation.definition.function"],
              "settings": {
                "foreground": "{{colors.tertiary.default.hex}}"
              }
            },
            {
              "name": "All Brackets",
              "scope": [
                "punctuation.definition.block.begin",
                "punctuation.definition.block.end",
                "punctuation.definition.array.begin",
                "punctuation.definition.array.end",
                "punctuation.definition.parameters.begin",
                "punctuation.definition.parameters.end",
                "punctuation.section.scope.begin",
                "punctuation.section.scope.end",
                "punctuation.definition.dictionary.begin",
                "punctuation.definition.dictionary.end",
                "punctuation.definition.group.begin",
                "punctuation.definition.group.end",
                "meta.brace.round",
                "meta.brace.square",
                "meta.brace.curly",
                "punctuation.section.brackets",
                "punctuation.section.parens",
                "punctuation.section.braces"
              ],
              "settings": {
                "foreground": "{{colors.primary.default.hex}}"
              }
            },
            {
              "name": "Operators",
              "scope": [
                "keyword.operator",
                "punctuation.separator",
                "punctuation.terminator"
              ],
              "settings": {
                "foreground": "{{colors.secondary.default.hex}}"
              }
            }
          ]
        }
      '';
    };
  };
}
