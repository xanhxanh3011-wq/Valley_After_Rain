# Godot 4 Import Guide

## Texture Defaults

Project default:

- `textures/canvas_textures/default_texture_filter=0`

This keeps pixel art sharp. Imported PNGs should keep:

- Filter nearest.
- Mipmaps off.
- Repeat disabled.
- Lossless compression for pixel art.

## Tile Size

Default runtime grid:

- `16x16`

Do not assume every character is `16x32`. Read the real sheet size and config the frame size per asset.

## Frame Rules

Horizontal 16px-high strips:

- `32x16` -> 2 frames of `16x16`.
- `48x16` -> 3 frames of `16x16`.
- `64x16` -> 4 frames of `16x16`.
- `96x16` -> 6 frames of `16x16`.

Character idle sheets currently used:

- `{name}_idle_16x16.png`
- `64x32`
- 4 frames of `16x32`

Full character sheets:

- `{name}_16x16.png`
- Use `frame_width/frame_height` from `data/characters.json`.
- Current main customers use `16x32` frames.

## Runtime Source Files

- Characters: `res://assets/limezu/characters_free/16x16/*.png`
- Animated objects: `res://assets/limezu/animated_objects/16x16/spritesheets/*.png`

## Godot 4 Work

- Build `SpriteFrames` from `AtlasTexture` regions in code when slicing differs per asset.
- Avoid `hframes/vframes` unless the whole sheet is uniform and documented.
- Keep node scale integer: `2x`, `3x`, etc.
