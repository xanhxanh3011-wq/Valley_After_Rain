# Asset Pipeline Audit - LimeZu Characters

## Asset Source

The original LimeZu character files were found in the shared workspace at:

`D:\GameMaking\game assets\Modern_Interiors\2_Characters\16x16`

The runtime copies used by Godot are exact copies under:

`res://assets/limezu/characters_free/16x16/`

No generated/blocky character sheets are used by the game.

## Characters Found

The source folder includes, among others:

- `Adam`
- `Alex`
- `Amelia`
- `Bob`
- `Chef_Alex`
- `Cleaner_girl`
- `Lucy`
- `Old_man_Josh`
- `Old_woman_Jenny`
- `Rob`
- `Samuel`

## Demo Character Mapping

- Player / Chủ quán: `Chef_Alex`
- Minh / tài xế: `Adam`
- Linh / văn phòng: `Amelia`
- Chú Bảy / bảo vệ: `Old_man_Josh`
- An / sinh viên: `Samuel`
- Cô Hạnh / bán hoa: `Old_woman_Jenny`
- Cặp đôi: `Lucy`
- Mai / y tá: `Cleaner_girl`
- Khoa / developer: `Rob`

The mapping lives in:

`res://data/characters.json`

## Verified Dimensions

Idle sheets:

- Pattern: `{name}_idle_16x16.png`
- Example: `Adam_idle_16x16.png`
- Size: `64x32`
- Frame size: `16x32`
- Frame order:
  - `Rect2(0, 0, 16, 32)` = `idle_left`
  - `Rect2(16, 0, 16, 32)` = `idle_up`
  - `Rect2(32, 0, 16, 32)` = `idle_down`
  - `Rect2(48, 0, 16, 32)` = `idle_right`

Full sheets:

- Pattern: `{name}_16x16.png`
- Many files in this workspace are larger than the public example, e.g. `Adam_16x16.png` is `768x288`.
- The frame size is still `16x32`.
- The loader validates that full sheet width/height are divisible by `16x32`.

Walk slicing currently used:

- `walk_row = 1`
- `walk_left_start_col = 12`
- `walk_frame_count = 6`
- Walk-left frames are:
  - `Rect2((12 + i) * 16, 1 * 32, 16, 32)`, `i = 0..5`
- `walk_right` reuses the same strip with `flip_h = true`.

Sit sheets:

- Pattern: `{name}_sit_16x16.png`
- If present, `seated_idle` uses the final visible front-facing group:
  - start column `18`
  - up to `6` frames
- If missing, `seated_idle` falls back to `idle_down`.

## Runtime Scripts

Animation is centralized in:

`res://scripts/visual/character_sprite_controller.gd`

Scene usage is in:

`res://scripts/game/night_cafe_game.gd`

The controller exposes:

- `configure(id, config, requested_animation)`
- `play_named(animation_name)`
- `set_animation_state(state, direction)`
- `face_down_or_seated()`

## Previous Bug

The earlier scene hardcoded `Rect2(0, 0, 32, 32)` and later used generated `32x48` character sheets. Both are incorrect for this requirement.

The current pipeline uses LimeZu `16x32` character frames only.

## Known Limitations

- `walk_up` and `walk_down` are not enabled yet because this pass only validated the clean side-profile walk strip requested for customer entry.
- Customers without a sit sheet fall back to `idle_down` behind the table/counter.
- The scene still uses some procedural rectangles for large floor/wall/counter blocks, while characters and animated props use asset sheets.
