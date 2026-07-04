# Đèn Hẻm Sau Mưa - Production Release Plan

## 0. Vai Trò Và Phạm Vi

Bạn là senior Godot 4.7 developer + game UI/UX designer. Hãy tự phân tích repo hiện tại của game `Đèn Hẻm Sau Mưa` và triển khai trực tiếp lên bản production release.

Trọng tâm ban đầu:
- Sửa `Recipe Book` và `Notebook` thành `open-book modal` đúng kiểu sách mở ở giữa màn hình.
- Book phải nổi lên trên cafe scene, có dim background phía sau, và khóa input gameplay khi mở.
- Tuyệt đối không render quyển sách như một widget bị nhét xuống bottom panel cũ.

## 1. Product Vision

`Đèn Hẻm Sau Mưa` là game cozy narrative về một quán ăn/quán cafe đêm ở thành phố Việt Nam hư cấu. Người chơi không cứu thế giới, không combat, không farm, không quản lý kinh doanh nặng. Trọng tâm là:
- Mở quán lúc đêm muộn.
- Nấu và pha món đúng lúc.
- Lắng nghe khách kể chuyện.
- Ghi nhớ chi tiết nhỏ.
- Tạo một nơi trú ẩn tinh thần cho những người cô đơn trong thành phố.

Release production phải giữ 3 trụ cột:
- Quán nhỏ có linh hồn.
- Món ăn/đồ uống có ý nghĩa cảm xúc.
- Nhân vật nói chuyện như người thật, tự nhiên, ngập ngừng, đời thường.

## 2. Production Scope

### 2.1 Core Release
- Main menu, settings, save/load.
- Cafe scene chính.
- Recipe Book modal.
- Notebook modal.
- Dialogue flow đầy đủ.
- Cooking/serving flow đầy đủ.
- 5 đêm playable tối thiểu, nhưng kiến trúc phải mở rộng được.
- Ít nhất 5 khách chính có arc rõ.
- Ít nhất 3 khách vãng lai.
- Ít nhất 1 memory dish moment chạm cảm xúc.
- Demo ending / full ending / credits.

### 2.2 Full Release Target
- 20-30 đêm nội dung.
- 8-10 khách chính.
- 12-18 khách vãng lai.
- 45-60 công thức.
- 25-35 món ký ức.
- Nhiều đêm đặc biệt theo thời tiết, mùa, sự kiện thành phố.
- Kết thúc theo hướng ký ức, không theo điểm số.

## 3. UI/UX Production Plan

### 3.1 Book Modal Standard
- `RecipeBookOverlay` là open-book modal ở giữa màn hình.
- `NotebookOverlay` là open-book modal ở giữa màn hình.
- Book chiếm khoảng 60-70% chiều rộng và 55-68% chiều cao ở `1280x720`.
- Cafe scene phía sau vẫn thấy được qua dim overlay.
- Bottom gameplay panel cũ bị ẩn, mờ, hoặc khóa input khi overlay đang mở.
- Z-index của book overlay phải cao hơn toàn bộ scene và UI thường.

### 3.2 Recipe Book Layout
- Trang trái là danh sách món.
- Trang phải là chi tiết món đang chọn.
- Có nút `Nấu món này` và `Quay lại trò chuyện`.
- Danh sách món lấy từ `demo_content.json`, không hardcode text giả.
- Nếu món nhiều, danh sách phải dùng `ScrollContainer` nội bộ.
- Không để list chồng lên art quyển sách.
- Không để text tràn khỏi khung.
- Không để một ký tự rơi xuống một dòng.

### 3.3 Notebook Layout
- Notebook là quyển sổ mở lớn ở giữa màn hình.
- Có tab:
  - `Khách quen`
  - `Công thức`
  - `Kỷ vật`
  - `Những đêm mưa`
  - `Ghi chú quán`
- Nội dung phải nằm gọn trong trang giấy.
- Text dài phải wrap theo từ hoặc scroll nội bộ.
- Notebook copy phải giống ghi chú của chủ quán, không giống debug UI.

### 3.4 UI Content Rules
- Mọi content trong book phải nằm trong `MarginContainer` + `VBoxContainer` + `HBoxContainer`.
- Page padding:
  - top `28-36px`
  - left/right `24-32px`
  - bottom `24-32px`
- Recipe row min height `52-72px`.
- Icon có width cố định.
- Label phải co giãn.
- Tag không được đè lên tên món.
- Action button phải cách text block `16-24px`.
- Không để horizontal overflow.
- Không để title/label đè lên mép sách.

### 3.5 UI Asset Requirements
- Nếu repo chưa có asset quyển sách/sổ đúng style, tạo asset mới trong `res://assets/generated/ui/`.
- Tối thiểu cần:
  - `ui_recipe_book_open.png`
  - `ui_notebook_open.png`
  - `ui_tab_paper.png`
  - `ui_note_sticky.png`
  - `ui_button_wood.png`
  - `ui_portrait_frame.png`
- Không bake chữ vào PNG.
- Mọi chữ phải là `Label` / `RichTextLabel` runtime để tiếng Việt có dấu đúng.
- Pixel art phải nearest, không scale lẻ.

## 4. Content Expansion Plan

### 4.1 Customers
- Mỗi khách chính có:
  - `name`
  - `age_range`
  - `job_context`
  - `speaking_style`
  - `usual_order`
  - `memory_dish`
  - `hidden_wound`
  - `emotion_arc`
  - `small_hook`
  - `keepsake_item`
- Arc phải đi qua nhiều đêm, không giải quyết quá nhanh.
- Có khách đi qua nhau trong đời thật nhưng chỉ chạm nhau nhẹ trong quán.

### 4.2 Recipes
- Món phải data-driven:
  - base
  - flavor tags
  - warmth level
  - caffeine level
  - comfort level
  - emotion tags
  - unlock condition
- Có món quen.
- Có món ký ức.
- Có món theo thời tiết / mùa / trạng thái khách.
- Có biến thể đúng lúc nhưng sai đêm.

### 4.3 Nights And Events
- Mỗi đêm có:
  - weather
  - ambience
  - opening text
  - customer queue
  - special event
  - closing reflection
- Có đêm mưa lớn, đêm yên, đêm mất điện, đêm lễ, đêm cuối tháng, đêm trước một thay đổi lớn.

### 4.4 Notebook Progression
- Notebook không phải inventory.
- Notebook là ký ức tích lũy của quán.
- Mỗi ghi chú phải phản ánh tiến triển cảm xúc của khách.
- Có trang bí mật mở khi đạt đủ manh mối.
- Có tab về món ký ức, kỷ vật, và ghi chú đêm trước.

### 4.5 World Progression
- Quán thay đổi rất nhẹ sau mỗi đêm.
- Vật trang trí mới xuất hiện từ kỷ vật của khách.
- Ánh sáng, radio, hoa, ly, note dán, ảnh cũ thay đổi theo tiến trình.
- Quán dần thành một nơi trú ẩn có ký ức.

## 5. Gameplay Systems

### 5.1 Required Systems
- Night loop: prep -> open -> serve/talk -> close.
- Dialogue tree theo thái độ.
- Recipe selection theo mood và ghi chú cũ.
- Customer walk-in / seated / leaving state machine.
- Notebook persistence.
- Save/load versioned.
- Sprite slice settings theo texture path.

### 5.2 Production Systems
- Mood system của quán.
- Memory system của khách.
- Relationship graph giữa khách.
- Keepsake system.
- Weather and time-of-night modifiers.
- End-of-night summary theo nhật ký quán.

### 5.3 Retention Systems
- Khách quay lại với thoại mới.
- Công thức mở khóa theo hành vi nhớ đúng.
- Khi người chơi nhớ chi tiết cũ, khách nhận ra.
- Quán đổi nhẹ theo tiến trình.
- New Game+ nếu cần cho hậu release.

## 6. Art Direction

### 6.1 Visual Standard
- Pixel art 16x16 thống nhất.
- Nearest filter, mipmaps off, repeat disabled.
- Không dùng scale lẻ.
- Không crop atlas sai.
- Không animate cả atlas.
- Không trộn pack khác pixel density nếu không có chủ đích rõ.

### 6.2 Scene Layers
- background / wall
- floor
- back props
- counter_back
- characters
- counter_front
- props_front
- fx
- UI

### 6.3 Asset Production
- Khách chính cần sprite sheet chuẩn.
- Props animated cần preset slice riêng trong `data/sprite_slice_presets.json`.
- UI production cần open-book sheet và các frame phụ.
- Portraits, notes, tabs, buttons phải cùng tone giấy/gỗ/amber.

## 7. Audio Plan

- Ambience loops:
  - mưa
  - quạt
  - xe xa xa
  - cửa mở
  - ly chạm nhẹ
- UI SFX:
  - lật sổ
  - click gỗ
  - chọn món
  - nhận món
- Cooking SFX:
  - rót
  - khuấy
  - sôi
  - múc
- Music:
  - lofi
  - jazz nhẹ
  - acoustic tối giản
- Tách bus:
  - Master
  - Music
  - Ambience
  - UI
  - SFX

## 8. Technical Plan

### 8.1 Architecture
- Giữ core game data-driven.
- Tách UI modal ra thành component rõ ràng.
- Giữ `CharacterSpriteController` làm interface animation duy nhất.
- Không để logic UI lẫn vào story data.

### 8.2 Data Structure
- `demo_content.json`:
  - game
  - recipes
  - customers
  - nights
  - demo_ending
- `characters.json`:
  - sprite paths
  - frame rules
  - state defaults
- `sprite_slice_presets.json`:
  - per texture path frame config
  - slice count
  - frame size
  - fps
  - loop

### 8.3 Save System
- Save version phải có.
- Có migration nếu schema đổi.
- Save riêng cho player data.
- Project presets ở `res://data/...`.
- User save ở `user://...`.

### 8.4 UI Rendering Rules
- Modal book dùng full overlay riêng.
- Không dùng bottom panel cũ cho book content.
- All text wrap phải dựa trên từ.
- Action buttons phải có spacing rõ.
- Scroll nội bộ cho list dài.

## 9. QA And Validation

### 9.1 Smoke Tests
- Boot to main menu.
- New game.
- Open Recipe Book.
- Close Recipe Book.
- Open Notebook.
- Close Notebook.
- Save and load.
- Progress one full night.
- Close game and reopen.

### 9.2 Visual Tests
- Book nằm giữa màn hình.
- Background dim đúng.
- Input bị khóa khi overlay mở.
- Text không overflow.
- Không có một chữ một dòng.
- Không có list đè art.
- Không có horizontal overflow.

### 9.3 Content Tests
- Ít nhất 5 khách chính có arc chạy được.
- Mỗi khách có ghi chú mở dần.
- Ít nhất 1 memory dish phản ứng rất rõ.
- Kỷ vật cập nhật đúng.
- Notebook phản ánh tiến triển đúng.

## 10. Release Milestones

### Milestone A
- UI overlay modal hoàn chỉnh.
- Text/layout không lỗi.
- Recipe Book và Notebook đúng chuẩn release.

### Milestone B
- Full content architecture data-driven.
- Thêm khách, món, đêm, sự kiện.
- Mở rộng notebook và recipe book.

### Milestone C
- Polish scene, lighting, layering, ambience.
- Sửa toàn bộ sprite slicing và animation mapping.
- Hoàn thiện visual consistency 16x16.

### Milestone D
- Audio integration.
- Save/load hardening.
- QA regression pass.

### Milestone E
- Release candidate.
- Build desktop.
- Playtest 30-60 phút.
- Chốt release notes và asset license notes.

## 11. Acceptance Criteria

- Recipe Book là open-book modal ở giữa màn hình.
- Notebook là open-book modal ở giữa màn hình.
- Book content không còn nằm dưới bottom panel cũ.
- Text không tràn, không lệch, không một ký tự một dòng.
- Overlay khóa input gameplay đúng cách.
- Game vẫn giữ full loop chạy được.
- Không crash.
- Không có parse/runtime error nghiêm trọng.
- Content data-driven đủ để mở rộng thành full release.

## 12. Post-Release Outlook

- Nếu cần, mở seasonal content.
- Nếu cần, mở hậu truyện hoặc New Game+.
- Nếu cần, thêm khách, đêm, hoặc một chi nhánh/quán khác.
- Giữ cùng tone: ấm, trầm, đời thường, không bi kịch hóa quá mức.

