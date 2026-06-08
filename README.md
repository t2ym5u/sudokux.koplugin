# Sudoku X

> **Status: stub — not yet implemented**

## Description

Standard 9×9 Sudoku with the additional rule that both main diagonals must also contain digits 1–9 without repetition.

## Files to create

- `board.lua` — game logic, puzzle generator, serialize/load
- `board_widget.lua` — grid rendering and tap gestures
- `screen.lua` — full-screen layout (buttons + board)
- `main.lua` — PluginBase entry point

## Notes

Shares rules with sudoku.koplugin; extend SudokuBoard base or copy and add variant constraints.
