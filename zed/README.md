# Zed

Vim bindings adapted from [`../IdeaVim/.ideavimrc`](../IdeaVim/.ideavimrc). Keep `vim_mode` enabled and the JetBrains base keymap. Leader is `Space`; the custom bindings apply in normal and visual modes, with code navigation restricted to normal mode.

The terminal shortcut below works throughout the workspace, including when the terminal is focused.

| Keys | Action |
|---|---|
| Command + backtick | Show / hide the terminal panel |
| `;` | Jump to a visible word using labels |
| `gd` / `gy` / `gi` / `gu` | Declaration / type definition / implementation / references |
| `Ctrl-o` / `Ctrl-i` | Back / forward |
| `scd` | Select the containing function (`vaf`) |
| `Space oi` | Organize imports |
| `<` / `>` in visual mode | Indent left / right, keeping the selection |
| `Space en` / `Space ep` | Next / previous error in the current file |
| `Space se` | Show hover information, including diagnostics |
| `Space c` | Toggle line comments |
| `Space x` | Focus the project tree; repeat or press `q` in the tree to close it |
| `Space q` | Close the active tab |
| `Space rn` | Rename symbol |
| `Space Space` / `Space ff` | Open the file finder (recent files with an empty query) |
| `Space fw` | Search the project |
| `Space fm` | Format the current file |
| `Tab` when a prediction is visible in normal mode | Accept Zed's edit prediction |

Settings also enable the system clipboard, relative line numbers, a 15-line scroll margin, smartcase search, and yank highlighting.

Autosave runs after 1 second of inactivity. Use `Space fm` to format explicitly; delayed autosave skips format-on-save. Which-key displays available key sequences after a 500 ms pause.

The project tree is docked on the left and the terminal on the right. Use `Space x` to focus the tree, then `q` or `Space x` to close it. Zed 1.25.2 has no built-in setting to automatically hide the project tree when it loses focus.

## Differences from IdeaVim

- `;` uses Zed's word jump labels rather than the AceJump plugin's character search.
- `scd` selects a function via Tree-sitter; it does not select every kind of ReSharper declaration. This requires the language grammar to support function text objects.
- `Space en` / `Space ep` navigate errors in the current file rather than ReSharper's solution-wide error list.
- `Space Space` shares Zed's file finder with `Space ff`, rather than opening JetBrains' separate Recent Files popup.
- `Tab` accepts Zed edit predictions; it does not invoke the Sweep JetBrains plugin. A configured prediction provider must supply the suggestion.
- Code navigation, rename, and organize imports depend on language-server support.
- IdeaVim's persistent-search-highlight settings are not copied; Zed manages search highlighting itself.

References: [Zed Vim mode](https://zed.dev/docs/vim), [key bindings](https://zed.dev/docs/key-bindings), and [actions](https://zed.dev/docs/all-actions).
