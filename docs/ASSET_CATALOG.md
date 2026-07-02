# Asset Catalog

Curated runtime subset copied from `D:\GameMaking\game assets`.

## Current Runtime Set

| Category | Project path | Use |
|---|---|---|
| LimeZu characters 16x16 | `res://assets/limezu/characters_free/16x16/` | Player and customers |
| LimeZu animated objects 16x16 | `res://assets/limezu/animated_objects/16x16/spritesheets/` | Cat, candle, coffee, pan, sink, toaster, clock |
| Shikashi icons | `res://assets/art/icons/shikashi/` | UI/icon references only |

## Default Grid

Current game runtime uses a `16x16` tile grid.

Rules:

- Props/furniture/world objects use `16x16` frames unless a larger source file is a valid multi-tile object.
- Character frame size is per-sheet config, not global.
- LimeZu idle character sheets currently used by main customers are `64x32` with `16x32` frames.
- Animated object strips such as `32x16`, `48x16`, `64x16`, `96x16` are sliced as horizontal `16x16` frames.

## Avoid

- Do not introduce generated/blocky character placeholders.
- Do not use the old 32px Modern Interiors runtime constants in the cafe demo scene.
- Do not use fractional scale on pixel art.
