# Sprite Sheet Slicer Plugin

This is a Godot editor tool, not an in-game UI.

## Location

- Plugin: `res://addons/sprite_sheet_slicer/`
- Presets: `res://data/sprite_slice_presets.json`
- Default output folder: `res://assets/spriteframes/`
- Runtime use: `scripts/game/night_cafe_game.gd` reads the same preset file before slicing animated props.

## How To Use

1. Open the project in Godot.
2. Go to `Project > Project Settings > Plugins`.
3. Ensure `Sprite Sheet Slicer` is enabled.
4. Open the right dock named `Sprite Sheet Slicer`.
5. Select a PNG spritesheet in the FileSystem dock, then click `Use selected FileSystem PNG`.
6. Enter:
   - `Frame width`
   - `Frame height`
   - `Start frame`
   - `Slice count`
   - `FPS`
   - `Loop`
7. Click `Save preset` to remember the settings for that exact texture path.
8. Click `Create SpriteFrames Resource` to export a `.tres` SpriteFrames resource.

The tool also saves the preset automatically when creating a SpriteFrames resource.
For the current cafe scene, saving the preset is enough for runtime animated props because the game reads `res://data/sprite_slice_presets.json` when creating `AnimatedSprite2D` props.

## Current Animated Object Presets

| Texture | Image size | Frame size | Slice count | Notes |
|---|---:|---:|---:|---|
| `animated_cat.png` | `576x16` | `48x16` | 12 | Cat strip. Do not slice as `16x16`. |
| `animated_candle.png` | `48x32` | `16x16` | 3 | First row only. |
| `animated_coffee.png` | `96x32` | `16x16` | 6 | First row only. |
| `animated_cuckoo_clock.png` | `160x32` | `16x16` | 10 | First row default. |
| `animated_kitchen_pan_with_omelette.png` | `256x32` | `16x16` | 16 | First row only. |
| `animated_kitchen_sink_1.png` | `96x16` | `16x16` | 6 | Full horizontal strip. |
| `animated_toaster.png` | `176x32` | `16x16` | 11 | First row default. |

## Rule

Do not guess frame size globally. Set and save the exact slice preset per spritesheet.
