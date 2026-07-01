# Asset Pipeline Audit

## Vấn đề đã phát hiện

- `scripts/game/night_cafe_game.gd` từng dùng `Rect2(0, 0, 32, 32)` cho cả nhân vật và prop.
- Các file Modern Interiors là sprite sheet nhiều frame/hàng, ví dụ:
  - `Adam_idle_anim_32x32.png`: `768x64`, grid 32px là `24x2`.
  - `Chef_Alex_32x32.png`: `768x192`, grid 32px là `24x6`.
  - `Old_man_Josh_32x32.png`: `1536x640`, grid 32px là `48x20`.
  - `animated_cat_32x32.png`: `1152x32`, grid 32px là `36x1`.
  - `animated_coffee_32x32.png`: `192x64`, grid 32px là `6x2`.
- Vì không có config animation/action, việc lấy frame đầu tiên làm mọi pose khiến nhân vật sai dáng, không có idle/walk, prop bị đứng hình hoặc nhìn như placeholder lỗi.
- Một số sprite trong scene bị render bằng `TextureRect` với kích thước không theo integer scale, gây cảm giác méo/mờ.

## Chuẩn đã áp dụng

- Nhân vật demo dùng sheet mới trong `assets/generated/characters`.
- Frame size thống nhất: `32x48`.
- Sheet size: `128x480`, tương đương 4 cột x 10 hàng.
- Nền trong suốt, padding đủ để không mất đầu/chân.
- Pivot runtime: bottom-center bằng `AnimatedSprite2D.offset = Vector2(0, -frame_height / 2)`.
- Scale runtime: `2x`, không dùng scale lẻ.
- Animation data nằm trong `data/characters.json`.
- Runtime controller tập trung ở `scripts/visual/character_sprite_controller.gd`.

## Animation Rows

- Row 0: `idle_down`
- Row 1: `walk_down`
- Row 2: `idle_left`
- Row 3: `walk_left`
- Row 4: `idle_right`
- Row 5: `walk_right`
- Row 6: `idle_up`
- Row 7: `walk_up`
- Row 8: `seated_idle`
- Row 9: `brew_idle` / `serve_down`

## Prop Handling

- Prop grid vẫn dùng frame 32px.
- Prop động quan trọng đã chuyển sang `AnimatedSprite2D` qua `_add_animated_prop`.
- Cat, candle, coffee và pan không còn bị render như frame tĩnh scale lẻ.
- Mưa, steam và lamp flicker được update trong `_process`.

## Cách thêm nhân vật mới

1. Tạo sheet `32x48`, 4 frame mỗi row, theo row chuẩn ở trên.
2. Đặt file vào `assets/generated/characters`.
3. Mở Godot editor/headless editor để import asset.
4. Thêm entry trong `data/characters.json`:

```json
{
	"display_name": "Tên nhân vật",
	"sheet": "res://assets/generated/characters/new_character_sheet.png",
	"frame_width": 32,
	"frame_height": 48,
	"scale": 2,
	"default_animation": "seated_idle",
	"default_direction": "down",
	"seat_offset": [0, 0],
	"animations": {}
}
```

Nếu `animations` để trống, controller dùng animation map mặc định.

## Kiểm thử bắt buộc

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path 'D:\GameMaking\idea-ready-game' --quit-after 1
```
