# Đèn Hẻm Sau Mưa - Production Release Plan

## 1. Product Vision

`Đèn Hẻm Sau Mưa` là game cozy narrative về một quán ăn/cafe nhỏ mở sau nửa đêm. Người chơi không giải cứu ai, không tối ưu doanh thu, không chạy deadline arcade. Người chơi tạo một không gian đủ ấm để khách ghé vào, gọi một món đúng lúc, và tự nói ra điều họ chưa biết nói với ai.

Release production cần giữ ba trụ cột:

- Quán nhỏ có linh hồn: ánh đèn vàng, mưa đêm, đồ vật tích lũy ký ức.
- Món ăn có ý nghĩa: công thức không chỉ là nguyên liệu mà là mood, thời tiết, ký ức.
- Nhân vật giống người thật: không giảng đạo, không bi kịch hóa liên tục, không giải quyết hoàn hảo mọi đời sống.

## 2. Target Release Scope

### Demo Public 1.0

- 5-7 đêm playable.
- 5 khách chính, 3 khách vãng lai.
- 15-20 công thức.
- 6-10 công thức mở khóa.
- 1 tuyến truyện hoàn chỉnh có khoảnh khắc món ký ức.
- 2 tuyến truyện cliffhanger nhẹ.
- Save/load ổn định.
- Settings cơ bản.
- Notebook/recipe book hoàn thiện UX.
- Scene quán polish đủ để trailer/screenshot.

### Early Access / Full Game

- 20-30 đêm.
- 8-10 khách chính.
- 12-18 khách vãng lai.
- 45-60 công thức.
- 25-35 món ký ức.
- 4 mùa/thời tiết đặc biệt.
- Multiple endings theo ký ức quán, không theo điểm số cứng.

## 3. Art Direction

### Scene

- Pixel art 16x16 thống nhất.
- Camera 16:9, integer scale, nearest filter.
- Quán chia layer rõ: wall, floor, back props, counter_back, characters, counter_front, props_front, fx, UI.
- Player sau quầy quay xuống khi chờ, khách ở quầy quay lên khi gọi món.
- Khách ở bàn dùng seated/idle_down đúng ngữ cảnh, bàn chỉ che phần chân/thân dưới.

### Asset Production Needs

- Sprite khách chính: idle 4 hướng, walk trái/phải, seated/table pose nếu có thể.
- Props animated chuẩn 16x16: mèo, nến, cà phê, hơi nước, mưa cửa sổ, đồng hồ, bếp/chảo.
- Menu/recipe icons theo nhóm: coffee, tea, milk, porridge, noodles, rice, bread, soup.
- Keepsake icons: ảnh cũ, hoa, note, vé xe, thẻ nhân viên, kẹp tóc, khăn tay.
- Background variants: mưa nhẹ, mưa lớn, đêm khô, gần sáng.

### Art QA Rules

- Không trộn 32x32 vào scene 16x16 trừ khi là object lớn ghép tile hợp lệ.
- Không scale lẻ.
- Không crop atlas.
- Không animate cả atlas.
- Mọi animated prop phải có preset trong `data/sprite_slice_presets.json`.

## 4. Narrative Plan

### Main Customers

- Minh, tài xế đêm: kiệt sức, sợ nghỉ là thua.
- Linh, nhân viên vừa nghỉ việc: trống rỗng, tự trách, học cách bắt đầu lại.
- Chú Bảy, bảo vệ ca đêm: ít nói, giữ ảnh cũ, món ký ức là cháo trứng.
- An, sinh viên làm đồ án: nói nhanh, tự ti, học lại niềm vui làm vì mình.
- Cô Hạnh, bán hoa đêm: dịu dàng, cô độc, đem hoa thừa về quán.

### Writing Rules

- Tiếng Việt tự nhiên, câu ngắn, có khoảng lặng.
- Lựa chọn im lặng phải có giá trị.
- Không biến chủ quán thành nhà trị liệu.
- Không dùng quest language như “hãy giúp tôi”.
- Không chốt mọi arc bằng happy ending sạch sẽ.

### Content Pipeline

- Mỗi khách có file data riêng sau phase refactor.
- Mỗi visit gồm: arrival, mood, choices, recipe_reactions, notes_unlock, trust_delta, keepsake.
- Mỗi món ký ức cần 3-5 manh mối trước khi mở phản ứng đặc biệt.
- Notebook copy viết như chủ quán tự ghi, không phải UI debug.

## 5. Gameplay Systems

### Must Have

- Night loop: prep -> open -> serve/talk -> close.
- Recipe selection by mood tags.
- Customer state: entering, counter_idle, seated_idle, talking, leaving.
- Slice preset settings for all 16x16 PNG props.
- Notebook: customers, recipes, memory dishes, keepsakes, previous nights.
- Save/load: current night, notes, trust, unlocked recipes, keepsakes, sprite presets.

### Should Have

- Side-panel recipe book during service.
- Weather-aware recipe hints.
- Dialogue choices unlocked by remembered details.
- Quán changes visually after keepsakes.
- Audio settings persisted.

### Won't Have

- Combat.
- Farming.
- Heavy shop management.
- Overcooked-style timers.
- Large map adventure.

## 6. UI/UX Plan

### Main Menu

- Lower panel uses large 2-column action cards.
- Buttons have title + short subtitle, no dense paragraph text.
- Title overlay must not cover scene after entering game.

### In-Game Bottom Panel

- Dialogue: portrait/name/text/choices.
- Recipe side panel: book-like layout, icon list on left, customer/mood notes on right.
- Cooking: preview item, tags, action buttons.
- Settings: grouped cards, not long debug forms.
- Notebook: paper tabs, handwritten-feeling copy.

### UX Acceptance

- No text squeezed to one letter per line.
- No horizontal overflow.
- Buttons have minimum height.
- Long descriptions go into panels/tooltips, not primary buttons.
- Every screen tells the player the next action.

## 7. Audio Plan

- Ambience loops: rain, distant motorbikes, fan hum, cup clink.
- UI SFX: soft wood click, page turn, recipe select, door bell.
- Cooking SFX: pour, stir, kettle, chopstick/cup.
- Music: late-night acoustic/lofi/jazz, sparse, low tempo.
- Mixer buses: Master, Music, Ambience, UI, SFX.

## 8. Technical Plan

### Architecture

- Keep content data-driven.
- Split current monolithic `night_cafe_game.gd` into:
  - `CafeSceneRenderer`
  - `DialogueController`
  - `RecipeController`
  - `NotebookController`
  - `SpriteSliceSettings`
  - `SaveService`
- Keep `CharacterSpriteController` as one animation interface.

### Asset Pipeline

- All texture import: nearest, mipmaps off, repeat disabled.
- 16x16 sprite settings stored per texture path.
- Character config stays per character, not global.
- Runtime never guesses if preset exists.

### Save Data

- Save version number.
- Migration function per save version.
- Separate user save from project presets:
  - Project presets: `res://data/sprite_slice_presets.json`.
  - Player save: `user://night_cafe_demo_save.json`.

## 9. QA Plan

### Smoke Tests

- Boot to main menu.
- New game -> prep -> open -> dialogue -> recipe -> serve -> next customer.
- Close night -> next night.
- Save/load mid-demo.
- Settings open/save sprite preset.
- Notebook open from each phase.
- Demo ending reachable.

### Visual QA

- Player not swallowed by counter.
- Counter guest faces up at counter.
- Table guests face camera/seated.
- Walk-in only triggers on first customer arrival screen.
- Props do not morph into unrelated atlas tiles.
- 16x16 asset list excludes 32x32 pack.

### Text QA

- Vietnamese signs display correctly.
- No mojibake in runtime.
- No one-letter-per-line labels.
- No clipped button labels on 1280x720.

## 10. Production Milestones

### Milestone A - Demo Stabilization

- Fix current visual bugs.
- Lock slice settings workflow.
- Polish main menu and recipe panel.
- Add basic idle motion.
- Run full demo flow.

### Milestone B - Content Expansion

- Finish all 5 customer arcs for demo.
- Add 3 vãng lai visits.
- Add 5-10 memory dish unlocks.
- Rewrite notebook copy pass.

### Milestone C - Art Polish

- Replace any rectangle-only furniture with real 16x16 assets where available.
- Add scene variants.
- Add keepsake shelf.
- Add customer portraits or clearer sprite callouts.

### Milestone D - Audio Integration

- Add ambience loops.
- Add UI/cooking SFX.
- Add volume settings persistence.

### Milestone E - Release Candidate

- Build Windows export.
- Fix console errors.
- Run 30-60 minute playtest.
- Capture screenshots/trailer clips.
- Prepare itch.io/Steam page copy.

## 11. Current Demo Acceptance Checklist

- Main menu usable and not cramped.
- Settings lists only 16x16 PNG assets.
- Slice presets save and affect runtime animated props.
- Character idle visibly moves subtly.
- Customer walk-in happens only on arrival, not every button press.
- Customer at counter faces the counter.
- Recipe menu uses readable large cards.
- Godot headless boot passes.
- Working tree clean after commit.
