# Demo Plan - Đèn Hẻm Sau Mưa

## 1. Vision

Một game kể chuyện tương tác, cozy, trầm, đời thường. Người chơi là chủ quán nhỏ mở từ 22:00 đến 04:00, nấu món đơn giản và lắng nghe những người cô đơn trong thành phố.

Không có combat, không level, không quản lý kinh doanh nặng. Tiến triển đến từ việc nhớ người, nhớ món, mở khóa công thức và để quán tích lũy vật kỷ niệm.

## 2. Core Loop

1. Trước khi mở quán: đọc thời tiết, ghi chú, chọn vài món nổi bật.
2. Trong đêm: khách bước vào, nói chuyện, người chơi chọn thái độ đáp lời.
3. Người chơi chọn món/đồ uống theo mood, lịch sử và manh mối.
4. Khách phản ứng: không hợp, tạm ổn, đúng lúc, hoặc món ký ức.
5. Sau khi đóng quán: sổ ghi chép cập nhật, công thức/vật kỷ niệm mở khóa.

## 3. Demo Scope

- 5 đêm playable.
- 5 khách chính: Minh, Linh, Chú Bảy, An, Cô Hạnh.
- 3 khách vãng lai: cặp đôi dưới một ô, Mai, Khoa.
- 19 công thức, gồm công thức ban đầu và công thức mở theo đêm.
- Ít nhất 3 khoảnh khắc món ký ức.
- Một tuyến khép nhẹ: Chú Bảy.
- Cliffhanger nhẹ: Linh và An.

## 4. Systems

- Main menu.
- Settings.
- Save/load.
- Night prep.
- Customer visit flow.
- Dialogue choice system.
- Recipe selection system.
- Recipe reaction system.
- Notebook.
- Recipe book.
- Keepsake tracking.
- Demo ending.

## 5. Content

Nội dung chính nằm trong `data/demo_content.json`:

- `customers`
- `recipes`
- `nights`
- `visits`
- `choices`
- `recipe_reactions`
- `demo_ending`

## 6. Data Structure

Customer:

- `name`
- `age`
- `short_description`
- `visual_hint`
- `speaking_style`
- `known_preferences`
- `disliked_flavors`
- `memory_dish`
- `hidden_wound`
- `keepsake_item`

Recipe:

- `id`
- `name`
- `type`
- `base`
- `ingredients`
- `flavor_tags`
- `emotion_tags`
- `warmth_level`
- `caffeine_level`
- `comfort_level`
- `description`
- `initial` or `unlock_night`

Night visit:

- `customer_id`
- `mood`
- `arrival`
- `lines`
- `choices`
- `good_recipes`
- `okay_recipes`
- `memory_recipe`
- `recipe_reactions`
- `notes_unlock`
- `keepsake`

## 7. UI Flow

Main Menu -> Prep -> Customer Dialogue -> Recipe Selection -> Reaction -> Next Customer -> Closing -> Next Night -> Ending.

Notebook and Recipe Book are available during play.

## 8. Art / Audio Direction

Current demo uses a cozy UI shell with warm panels, rain visuals, and imported pixel-art assets for cafe props, customer sprites, and recipe presentation. Audio is intentionally noted but not fully implemented yet; next polish pass should add rain, bell, cup, and low-volume loop music.

## 9. Implementation Steps Done

- Replaced starter scene with `NightCafeGame`.
- Added data-driven content JSON.
- Added state machine UI in `scripts/game/night_cafe_game.gd`.
- Added save/load to `user://night_cafe_demo_save.json`.
- Added notebook, recipe book, settings, ending.
- Added asset-backed visual stage using Modern Interiors characters and animated props.

## 10. Acceptance Criteria

- Game opens to main menu.
- New game can play through 5 nights.
- Each customer can be answered and served.
- Recipe reactions differ by customer and dish.
- Notebook updates with notes and keepsakes.
- Recipe book shows unlocks.
- Save/load works.
- Demo ending appears after night 5.
- Content is Vietnamese with dấu.
- Godot headless parse exits without errors.

## 11. Polish Before Public Demo

- Add real audio ambience and simple SFX.
- Replace current asset-backed UI stage with a composed cafe scene.
- Add larger portraits or cropped character sprites per customer.
- Add animated steam/rain/cat.
- Add text pacing and click-to-advance lines.
- Add manual save slots.
- Verify all asset licenses before public release.

## 12. Run

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --path 'D:\GameMaking\idea-ready-game'
```

## 13. After Demo

- Expand to 7-10 nights.
- Deepen linked customer stories.
- Add weather-specific menu logic.
- Add a visual notebook layout.
- Add map/cafe interaction layer after narrative loop is stable.
