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

Seated runtime:

- Seated/chờ ở bàn hiện dùng `idle_down` từ idle sheet.
- Runtime frame là `Rect2(32, 0, 16, 32)`.
- `flip_h = false`.
- Đây là quyết định cố ý vì các `{name}_sit_16x16.png` hiện có trong workspace là side-profile strip, làm NPC ở bàn bị quay ngang.

Sit sheets:

- Pattern: `{name}_sit_16x16.png`
- Sit sheets are imported but not used by default.
- They can be enabled per character later with `use_seated_pose = true` only after visually confirming that the selected frames are front-facing and suitable for a table/counter pose.

## Runtime Scripts

Animation is centralized in:

`res://scripts/visual/character_sprite_controller.gd`

Scene usage is in:

`res://scripts/game/night_cafe_game.gd`

The controller exposes:

- `configure(id, config, requested_animation)`
- `play_named(animation_name)`
- `set_animation_state(state, direction)`
- `sit_down()`
- `face_down_or_seated()`

Scene-level customer walk-in state currently uses:

- `walking_to_seat`
- `seated_idle`

When the customer reaches the seat, the scene calls `sit_down()`, zeroes velocity, sets `flip_h = false`, and keeps the character on `idle_down`.

## Previous Bug

The earlier scene hardcoded `Rect2(0, 0, 32, 32)` and later used generated `32x48` character sheets. Both are incorrect for this requirement.

The current pipeline uses LimeZu `16x32` character frames only.

## Known Limitations

- `walk_up` and `walk_down` are not enabled yet because this pass only validated the clean side-profile walk strip requested for customer entry.
- Sit sheets are not used by default because their current visible strips are side-facing; customers use `idle_down` after sitting.
- The scene still uses some procedural rectangles for large floor/wall/counter blocks, while characters and animated props use asset sheets.
