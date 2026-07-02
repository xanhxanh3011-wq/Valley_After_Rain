# Sprite Slice Settings

Sprite slicing is configured inside the game Settings screen, not through an editor plugin.

## Location

- UI: Main Menu -> `Cài đặt` -> `Cấu hình slice sprite asset`
- Saved presets: `res://data/sprite_slice_presets.json`
- Runtime reader: `scripts/game/night_cafe_game.gd`

## How It Works

Each preset is keyed by the exact texture path:

```json
"res://assets/limezu/animated_objects/16x16/spritesheets/animated_cat.png": {
	"frame_width": 48,
	"frame_height": 16,
	"start_frame": 0,
	"slice_count": 12,
	"fps": 4,
	"loop": true
}
```

When gameplay code creates an animated prop with that same texture path, the runtime uses the saved preset instead of guessing frame size or frame count.

## Current Presets

| Texture | Frame size | Slice count | Notes |
|---|---:|---:|---|
| `animated_cat.png` | `48x16` | 12 | Cat strip. |
| `animated_candle.png` | `16x16` | 3 | First row only. |
| `animated_coffee.png` | `16x16` | 6 | First row only. |
| `animated_cuckoo_clock.png` | `16x16` | 10 | First row only. |
| `animated_kitchen_pan_with_omelette.png` | `16x16` | 16 | First row only. |
| `animated_kitchen_sink_1.png` | `16x16` | 6 | Horizontal strip. |
| `animated_toaster.png` | `16x16` | 11 | First row only. |

## Rule

Do not hardcode one frame size for all sprites. Set the exact preset per PNG asset in Settings, save it, then let runtime code read the preset by texture path.
