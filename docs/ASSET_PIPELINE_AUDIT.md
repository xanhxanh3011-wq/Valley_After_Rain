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
  - `Rect2(0, 0, 16, 32)` = `idle_right`
  - `Rect2(16, 0, 16, 32)` = `idle_up`
  - `Rect2(32, 0, 16, 32)` = `idle_left`
  - `Rect2(48, 0, 16, 32)` = `idle_down`
  - Note: this was visually verified from `Adam_idle_16x16.png`; frame `3`, not frame `2`, is the front-facing/camera-facing pose.

Full sheets:

- Pattern: `{name}_16x16.png`
- Many files in this workspace are larger than the public example, e.g. `Adam_16x16.png` is `768x288`.
- The frame size is still `16x32`.
- The loader validates that full sheet width/height are divisible by `16x32`.

Important: `16x32` is not a global character default. It is the configured frame size for the currently mapped LimeZu customer sheets. The controller reads `frame_width` and `frame_height` from `data/characters.json`.

`CharacterSpriteController` also supports per-sheet overrides:

- `idle_frame_width` / `idle_frame_height`
- `full_frame_width` / `full_frame_height`
- `sit_frame_width` / `sit_frame_height`

Current mixed-size case:

- `Cleaner_girl_idle_16x16.png`: `64x32`, idle frame `16x32`.
- `Cleaner_girl_16x16.png`: `384x112`, full/walk frame `16x16`.
- `y_ta` therefore keeps `frame_height = 32` for idle display and sets `full_frame_height = 16` for the full walk sheet.

Walk slicing currently used:

- `walk_row = 1`
- `walk_left_start_col = 12`
- `walk_frame_count = 6`
- Walk-left frames are:
  - `Rect2((12 + i) * 16, 1 * 32, 16, 32)`, `i = 0..5`
- `walk_right` reuses the same strip with `flip_h = true`.

Seated runtime:

- Seated/chờ ở bàn hiện dùng `idle_down` từ idle sheet.
- Runtime frame là `Rect2(48, 0, 16, 32)`.
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

When the customer reaches the seat, the scene calls `play_seated()`, zeroes velocity, sets `flip_h = false`, and keeps the character on front-facing `idle_down`.

## Animated Object Audit

Runtime prop files are exact copies from:

`D:\GameMaking\game assets\Modern_Interiors\3_Animated_objects\16x16\spritesheets`

The asset pack also includes 16px GIF previews under `3_Animated_objects\16x16\gif`, including cat/candle/coffee. Godot 4.7 does not load those GIF files as textures in this project (`ResourceLoader.load()` returns `null`), so `GifDecorationLoader` accepts the GIF path as a decoration handle and resolves it to the matching PNG sprite sheet/strip. This keeps the same source art while remaining loadable by Godot.

Runtime GIF decoration handles copied into the project:

- `res://assets/limezu/animated_objects/16x16/gif/animated_cat.gif`
- `res://assets/limezu/animated_objects/16x16/gif/animated_candle.gif`
- `res://assets/limezu/animated_objects/16x16/gif/animated_coffee.gif`
- `res://assets/limezu/animated_objects/16x16/gif/animated_kitchen_pan_with_omelette_16x16.gif`

Loader:

- `res://scripts/visual/gif_decoration_loader.gd`
- `animated_cat.gif` -> `animated_cat.png`, frames `0..35`
- `animated_candle.gif` -> `animated_candle.png`, frames `0..2`
- `animated_coffee.gif` -> `animated_coffee.png`, frames `0..5`
- `animated_kitchen_pan_with_omelette_16x16.gif` -> `animated_kitchen_pan_with_omelette.png`, frames `0..15`

Project path:

`res://assets/limezu/animated_objects/16x16/spritesheets/`

| File | Size | Frame | Texture frames | Runtime strip | Layout | Scene usage |
|---|---:|---:|---:|---|---|
| `animated_cat.png` | `576x16` | `16x16` | 36 | frames `0..35` | Horizontal strip | Cat at lower-left corner |
| `animated_coffee.png` | `96x32` | `16x16` | 12 | frames `0..5` only | Multi-row grid | Cup/coffee on counter and recipe icon |
| `animated_candle.png` | `48x32` | `16x16` | 6 | frames `0..2` only | Multi-row grid | Candle on counter |
| `animated_kitchen_pan_with_omelette.png` | `256x32` | `16x16` | 32 | frames `0..15` only | Multi-row grid | Hot food/pan on counter and recipe icon |
| `animated_kitchen_sink_1.png` | `96x16` | `16x16` | 6 | frames `0..5` | Horizontal strip | Sink/counter prop |
| `animated_toaster.png` | `176x32` | `16x16` | 22 | frame `0` for static icon | Multi-row grid | Bread/recipe icon |
| `animated_cuckoo_clock.png` | `160x32` | `16x16` | 20 | frame `0` unless animated later | Multi-row grid | Available for clock prop/UI stage |

The scene helper `_add_animated_prop()` now accepts `frame_size`, `frame_count`, and `start_frame`. Multi-row atlases must pass an explicit `frame_count` so props do not animate into a different object variant on the next row. It supports:

- `32x16` -> 2 frames of `16x16`.
- `48x16` -> 3 frames of `16x16`.
- `64x16` -> 4 frames of `16x16`.
- `96x16` -> 6 frames of `16x16`.
- Multi-row grids where width/height are divisible by the configured frame size.

## Runtime Scale / Nodes

Main scene: `res://scenes/main/NightCafeGame.tscn`

Runtime script: `res://scripts/game/night_cafe_game.gd`

| Runtime element | Node/helper | Asset | Frame | Scale |
|---|---|---|---|---:|
| Player | `CharacterSpriteController` | `Chef_Alex_idle_16x16.png` / `Chef_Alex_16x16.png` | `16x32` | `3x` |
| Customers | `CharacterSpriteController` | mapped in `data/characters.json` | `16x32` | `3x` |
| Cat lower-left | `_add_animated_prop` | `animated_cat.png` | `16x16`, 36 frames | `3x` |
| Coffee/cup | `_add_animated_prop` / `_asset_texture_rect` | `animated_coffee.png` | `16x16`, runtime frames `0..5` | `3x` scene, `5x/3x` UI |
| Candle | `_add_animated_prop` | `animated_candle.png` | `16x16`, runtime frames `0..2` | `3x` |
| Pan/hot food | `_add_animated_prop` / `_asset_texture_rect` | `animated_kitchen_pan_with_omelette.png` | `16x16`, runtime frames `0..15` | `3x` scene, `5x/3x` UI |
| Sink | `_add_animated_prop` | `animated_kitchen_sink_1.png` | `16x16`, 6 frames | `3x` |
| Toaster/recipe icon | `_asset_texture_rect` | `animated_toaster.png` | `16x16` | `5x/3x` UI |

No runtime node now uses the old `animated_*_32x32.png` paths.

## World Scene Seating / Layering Audit

Current runtime node generation in `night_cafe_game.gd`:

| Runtime element | Node type | Texture / source | Position / z rule | Notes |
|---|---|---|---|---|
| Player behind counter | `CharacterSpriteController` | `Chef_Alex_idle_16x16.png`, `16x32` idle frame | foot `Vector2(640, 248)`, z by y | Counter front is only `y=238..256`, so it covers lower body only. |
| Active walk-in customer | `CharacterSpriteController` | mapped LimeZu character sheet | path `1260,292 -> 1136,292 -> 876,292 -> 642,292` | Walks left/right, then snaps to counter seat and plays `seated_idle`. |
| Flower seller seat | `CharacterSpriteController` | `Old_woman_Jenny_*` | foot `Vector2(210, 300)` | Front overlay is `y=292..300`, so only lower body is hidden. |
| Guard seat | `CharacterSpriteController` | `Old_man_Josh_*` | foot `Vector2(1058, 300)` | Uses `seated_idle`, not side/walk frame. |
| Student seat | `CharacterSpriteController` | `Samuel_*` | foot `Vector2(416, 352)` | Front overlay is `y=346..354`, only lower body is hidden. |
| Counter guest seat | `CharacterSpriteController` | mapped LimeZu character sheet | foot `Vector2(642, 292)` | Seat lip is `y=286..294`, z `310`. |
| Steam | `ColorRect` ambience FX | procedural, no atlas | z `318` | No sprite atlas involved. |
| Rain | `ColorRect` ambience FX | procedural, no atlas | default world overlay | No sprite atlas involved. |

`CharacterSpriteController.play_seated()` now forces:

- `state = "seated_idle"`
- `last_direction = "down"`
- `flip_h = false`
- animation `seated_idle`, which falls back to the front-facing `idle_down` frame unless a validated seated pose is explicitly enabled.

This prevents customers from keeping `walk_left`, `walk_right`, or `idle_left` after reaching a table.

## Fixed Slicing / Scale Issues

- Cat previously used `animated_cat_32x32.png` from the 32px folder. It now uses `animated_cat.png` from the 16px LimeZu folder, sliced as 36 frames of `16x16`, scale `3x`.
- Coffee/candle/pan/sink/toaster previously used 32px animated object paths. They now use 16px LimeZu files and grid-slice `16x16`.
- Coffee/candle/pan previously risked animating across the whole multi-row atlas. Runtime now uses only the first-row strip for each object.
- `_add_animated_prop()` previously assumed a 32px horizontal strip. It now reads actual texture width/height, frame size, frame count, and optional start frame.
- `_add_animated_prop()` now also guards multi-row atlases: if no `frame_count` is provided, only the first row is animated and a warning is emitted.
- `_add_scene_sprite()` default region now uses `AssetCatalog.TILE_SIZE`, currently `16`.
- `AssetCatalog.TILE_SIZE` is now `16`.
- UI recipe icon sizes were changed to integer multiples of `16` (`80px` or `48px`) to avoid fractional scaling.
- Old generated/blocky character assets were removed.

## Previous Bug

The earlier scene hardcoded `Rect2(0, 0, 32, 32)` and later used generated 32px-height placeholder character sheets. Both are incorrect for this requirement.

The current pipeline uses per-asset frame sizes:

- Current mapped LimeZu characters: `16x32`.
- Runtime animated props/animal/fx: `16x16`.

## Known Limitations

- `walk_up` and `walk_down` are not enabled yet because this pass only validated the clean side-profile walk strip requested for customer entry.
- Sit sheets are not used by default because their current visible strips are side-facing; customers use `idle_down` after sitting.
- The scene still uses some procedural rectangles for large floor/wall/counter blocks, while characters and animated props use asset sheets.
