# Đèn Hẻm Sau Mưa — UI/UX Game Design Brief cho Codex

> Mục tiêu của file này: đưa cho Codex/CodexAI một bản chỉ đạo rõ ràng để nâng UI/UX của demo `Đèn Hẻm Sau Mưa` từ prototype text-panel lên một vertical slice có cảm giác game indie hoàn chỉnh. Codex phải ưu tiên dùng assets sẵn có trong repo; nếu thiếu asset UI như quyển sách, paper panel, frame gỗ, tab giấy, keepsake slot thì tự tạo asset UI mới bằng CodexAI hoặc bằng script sinh pixel-art/procedural texture, lưu vào `res://assets/generated/ui/` và sử dụng ngay trong runtime.

---

## 0. Nguyên tắc làm việc cho Codex

1. Tự phân tích repo hiện tại trước khi sửa.
2. Không hỏi lại nếu có thể tự quyết theo tài liệu này.
3. Không phá gameplay loop đang chạy được.
4. Không thay nội dung tiếng Việt có dấu thành tiếng Anh.
5. Không dùng ảnh AI reference làm ảnh nền UI trực tiếp nếu trong ảnh có chữ sai, chữ méo, hoặc layout không đúng runtime.
6. Reference images chỉ dùng để học bố cục, mood, vật liệu UI, không dùng để paste nguyên vào game.
7. Ưu tiên Godot `Control`, `Theme`, `StyleBoxFlat`, `PanelContainer`, `MarginContainer`, `VBoxContainer`, `HBoxContainer`, `GridContainer`, `ScrollContainer`, `TextureRect`, `Label`, `RichTextLabel`, `Button`.
8. Text thật trong game phải là `Label`/`RichTextLabel` để đọc rõ, hỗ trợ tiếng Việt và không bị AI vẽ sai chữ.
9. Pixel art phải sharp: nearest filtering, không scale lẻ, không blur.
10. Nếu asset thiếu, tạo asset mới gọn, nhất quán, hợp style, rồi dùng; không để placeholder xấu.

---

## 1. Vision UI/UX

`Đèn Hẻm Sau Mưa` là game cozy narrative về một quán ăn/cafe nhỏ mở sau 22:00. Người chơi là chủ quán, lắng nghe khách đêm, chọn món theo mood, thời tiết, ký ức và phản ứng của từng người.

UI phải làm người chơi cảm thấy:

- đang ngồi trong một quán nhỏ ấm ánh đèn vàng;
- mọi nút bấm giống thẻ menu, tấm giấy ghi chú, bìa sổ, mặt gỗ cũ;
- lựa chọn món ăn không phải inventory RPG mà là hành động quan tâm;
- sổ ghi chép là trái tim của game, nơi nhớ người, nhớ món, nhớ kỷ vật;
- không có áp lực combat, timer, tiền, score, star rating.

---

## 2. Phân tích 5 ảnh reference AI

### 2.1. Ảnh Main Menu

**Điểm mạnh**

- Mood rất đúng: quán nhỏ, mưa đêm, ánh vàng trong nhà đối lập xanh xám ngoài hẻm.
- Logo/title có cảm giác cozy, hợp game kể chuyện.
- Menu button lớn, dễ hiểu, phù hợp người chơi casual.
- Bối cảnh có nhiều chi tiết tốt: cửa mở, bảng menu, đồng hồ, nồi bốc khói, mèo, phản chiếu nước mưa.

**Điểm yếu cần tránh khi đưa vào game**

- Ảnh vuông, không đúng runtime 16:9.
- Title quá lớn, chiếm nhiều cảnh; trong game thật nên không che scene sau khi vào gameplay.
- Chữ trong ảnh AI có thể đẹp ở screenshot nhưng không nên dùng làm text bitmap; phải render bằng UI Label.
- Các button hơi giống màn title riêng, chưa có save/load slot, subtitle button, confirmation modal.
- Style nền đẹp hơn assets runtime hiện có; nếu áp dụng cần hoặc tạo background mới, hoặc chỉ lấy mood màu/ánh sáng.

**Áp dụng vào production**

- Dùng làm hướng `MainMenuScreen`: title lớn, subtitle nhỏ, menu bên phải hoặc lower-right.
- Button dùng frame gỗ + inner dark fill + hover amber glow.
- Không dùng nguyên ảnh, chỉ tái tạo bằng scene/runtime UI.

---

### 2.2. Ảnh Gameplay Dialogue / Minh

**Điểm mạnh**

- Cấu trúc UI rất đáng học: scene trên, panel dưới, portrait trái, dialogue giữa, note phải, choice ở dưới.
- Có time indicator `00:37`, có note gợi ý trí nhớ, có mood tags.
- Người chơi nhìn là hiểu đang trò chuyện và sắp chọn món.
- Bảng gỗ phía dưới có chất game hơn prototype hiện tại.

**Điểm yếu cần tránh**

- Text AI bị sai: `Trà gừng ét đường`, `Lậu`, có thể sai dấu/sai chữ.
- Top navigation quá nhỏ, hơi giống nút browser; cần đồng bộ với tab/button game.
- Scene character lớn hơn runtime 16x32 hiện tại; nếu không có sprite tương ứng thì không nên copy scale này.
- Portrait Minh cần làm từ crop sprite hoặc generated portrait riêng, nhưng phải đồng bộ với character mapping.
- Choice buttons mới có 2 lựa chọn, game cần hỗ trợ 2–4 lựa chọn tùy visit.

**Áp dụng vào production**

- Đây là layout gameplay chính nên ưu tiên triển khai đầu tiên.
- Tạo `DialoguePanel`: portrait/name/mood/line/choices/memory note/time strip.
- Tách narrator line, customer line, player choice thành style riêng.

---

### 2.3. Ảnh Cinematic Dialogue / Linh

**Điểm mạnh**

- Bố cục đối thoại rõ hơn: tabs ở trên panel, portrait lớn, paper dialogue, lựa chọn bên phải.
- Khung giấy lớn giúp text dài dễ đọc.
- Mood chip và recipe hint đặt cùng ngữ cảnh, rất hợp loop chọn món theo cảm xúc.
- Màu teal/muted blue dùng tốt để nhấn chip/gợi ý mà không phá tông nâu vàng.

**Điểm yếu cần tránh**

- Text AI lỗi dấu và lỗi từ: `không hơi bị`, chip lặp `mệt mệt`, chữ bị mất nghĩa.
- Portrait có thể lệch style với 16x16 LimeZu; nếu tạo portrait mới thì cần tạo cả bộ cho tất cả khách chính.
- Background scene không khớp trực tiếp với assets hiện tại; chỉ dùng làm reference.
- Các nút lựa chọn bên phải hơi lớn, nếu viewport 1280x720 cần kiểm tra không overflow.

**Áp dụng vào production**

- Dùng layout này cho `CustomerDialogueState` khi đang nói chuyện sâu.
- Chọn phong cách paper-card làm chuẩn UI.
- Làm choice card có icon nhỏ và trạng thái hover/focus/selected.

---

### 2.4. Ảnh Notebook / Sổ ghi chép

**Điểm mạnh**

- Quyển sổ mở là asset/UI motif rất hợp game.
- Tabs giấy phía trên rất tốt: `Khách quen`, `Công thức`, `Kỷ vật`, `Những đêm mưa`.
- Có sticky note, tape, coffee stain, keepsake slot; đúng tinh thần game ký ức.
- Background quán mờ sau lưng tạo cảm giác đang mở sổ trong quán, không tách khỏi world.

**Điểm yếu cần tránh**

- Ảnh vuông, không đúng 16:9.
- Text bị trộn Anh-Việt: `Known preferences`, `Memory clues`, `Keepsake slot`.
- Một số lỗi tiếng Việt: `ca dem`, `mat tấm`, `cũ trắng vì`.
- Quyển sách không có trong assets hiện tại; không được để Codex bí ở đây. Codex phải tự tạo `book_panel` asset hoặc dựng bằng Control/StyleBox.
- Nếu dùng texture book lớn, cần nine-slice hoặc layout responsive, không hardcode ảnh một kích thước.

**Áp dụng vào production**

- Bắt buộc tạo màn `NotebookScreen` kiểu quyển sổ.
- Nếu thiếu asset, tạo `res://assets/generated/ui/notebook_open.png`, `paper_tab.png`, `sticky_note.png`, `keepsake_slot.png`.
- Tất cả text notebook phải là Label, tiếng Việt hoàn toàn.

---

### 2.5. Ảnh Recipe Book / Chọn món

**Điểm mạnh**

- Đây là hướng tốt nhất cho màn chọn món: open book, list món bên trái, detail món bên phải.
- Icon món ăn rõ, spacing ổn, CTA `Nấu món này` và `Quay lại trò chuyện` đúng flow.
- Phần ghi chú khách hàng nằm ngay trong recipe detail, rất đúng gameplay chọn món theo người.
- Background dimmed cafe phía sau giúp UI nổi bật.

**Điểm yếu cần tránh**

- Text AI sai nhiều: `Cà chê phin`, `Gợi nhó`, một số tag vô nghĩa.
- Có món bị lặp `Cháo nóng`, `Mì trứng`; runtime cần render theo data thật từ `demo_content.json`.
- Quyển sách chưa có asset sẵn; cần tạo/generated.
- UI quá lớn có thể che hết scene; trong gameplay nên có dim overlay nhưng vẫn thấy quán.

**Áp dụng vào production**

- Màn `RecipeSelectionScreen` nên dựa mạnh vào reference này.
- Implement filter chips: `Tất cả`, `Đồ uống`, `Món nóng`, `Ít ngọt`, `Kỷ niệm`.
- Detail panel hiển thị: description, warmth/caffeine/comfort, mood tags, customer hint, weather hint.

---

## 3. Chuẩn layout runtime

### 3.1. Canvas

Target: `1280x720`, 16:9.

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  Cafe Scene / Stage Area                                    │
│  y = 0..432 hoặc 0..456                                     │
│  khoảng 60–65% màn hình                                     │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  Main Interaction UI Panel                                  │
│  y = 432..720 hoặc 456..720                                 │
│  khoảng 35–40% màn hình                                     │
└─────────────────────────────────────────────────────────────┘
```

Không để scene bị UI che tùy tiện. Khi mở notebook/recipe book full-screen, dùng dim overlay nhưng vẫn thấy quán mờ phía sau.

### 3.2. Safe margins

- Outer margin: `16px` hoặc `24px`.
- Panel padding: `16px`.
- Gap giữa card: `8px` hoặc `12px`.
- Button height tối thiểu: `44px`; choice button nên `52–64px`.
- Font size body tối thiểu: `18px` ở 1280x720.
- Title: `28–36px`.
- Small meta/tag: không dưới `14px`.

---

## 4. Palette chuẩn

```gdscript
const COLOR_BG_DARK       = Color("#1b1009")
const COLOR_PANEL         = Color("#24150d")
const COLOR_CARD          = Color("#3a261a")
const COLOR_BORDER        = Color("#6b4728")
const COLOR_AMBER         = Color("#d7a64b")
const COLOR_TEXT          = Color("#f1d8a0")
const COLOR_MUTED_TEXT    = Color("#9d8464")
const COLOR_WOOD_FLOOR    = Color("#5a351c")
const COLOR_RAIN_BLUE     = Color("#18202a")
const COLOR_NOTE_PAPER    = Color("#ead6a3")
const COLOR_NOTE_INK      = Color("#3a261a")
const COLOR_TEAL_ACCENT   = Color("#789f9a")
const COLOR_DANGER_SOFT   = Color("#b56a4a")
```

---

## 5. Asset policy

### 5.1. Existing assets phải ưu tiên

Codex phải tìm và dùng trước:

- Characters: `res://assets/limezu/characters_free/16x16/`
- Animated props: `res://assets/limezu/animated_objects/16x16/spritesheets/`
- Icons: `res://assets/art/icons/shikashi/`
- Character mapping: `res://data/characters.json`
- Content: `res://data/demo_content.json`
- Sprite slice presets: `res://data/sprite_slice_presets.json`

### 5.2. Không được tái phạm lỗi asset cũ

- Không dùng old 32px Modern Interiors runtime constants.
- Không hardcode mọi sprite là `32x32`.
- Không hardcode mọi character là `16x32`; đọc config thực tế.
- Không animate toàn bộ atlas nhiều hàng.
- Không scale lẻ.
- Không để NPC giữ `walk_left` sau khi ngồi.
- Không để bàn/quầy che mặt nhân vật.

### 5.3. Khi thiếu asset UI

Nếu repo không có các asset sau, Codex phải tự tạo:

```
res://assets/generated/ui/
  ui_panel_wood.png
  ui_panel_paper.png
  ui_button_wood.png
  ui_button_wood_hover.png
  ui_button_wood_pressed.png
  ui_choice_card.png
  ui_choice_card_hover.png
  ui_tab_paper.png
  ui_tab_paper_selected.png
  ui_portrait_frame.png
  ui_note_sticky.png
  ui_notebook_open.png
  ui_recipe_book_open.png
  ui_keepsake_slot.png
  ui_scroll_thumb.png
  ui_scroll_track.png
```

Cách tạo chấp nhận được:

1. Dùng CodexAI tạo pixel-art UI texture original.
2. Hoặc viết script Godot/Python sinh texture đơn giản bằng rectangles, borders, corner pixels, noise nhẹ, paper stains.
3. Hoặc dùng `StyleBoxFlat` nếu texture chưa cần thiết.

Yêu cầu với generated assets:

- Pixel-art style, không blur.
- Kích thước nên là bội số của `16` hoặc dùng nine-slice hợp lý.
- Không chứa chữ bake vào ảnh, trừ logo/title nếu muốn; text UI phải render runtime.
- Lưu attribution nếu dùng bất kỳ nguồn ngoài nào; tốt nhất là tự tạo procedural để sạch license.

---

## 6. UI component system cần implement

Tạo một hệ thống UI tái sử dụng, không vẽ từng màn bằng code lặp.

Đề xuất file:

```
res://scripts/ui/night_ui_theme.gd
res://scripts/ui/night_ui_factory.gd
res://scripts/ui/ui_components/dialogue_panel.gd
res://scripts/ui/ui_components/recipe_book_panel.gd
res://scripts/ui/ui_components/notebook_panel.gd
res://scripts/ui/ui_components/reaction_panel.gd
res://scripts/ui/ui_components/end_night_summary_panel.gd
```

Nếu muốn ít file hơn, vẫn phải có helper tương đương trong `night_cafe_game.gd` hoặc một factory riêng.

### 6.1. Components bắt buộc

#### `WoodPanel`

Dùng cho bottom panel, modal, button frame.

- Fill: `#24150d`
- Border: `#6b4728`
- Accent line: `#d7a64b`
- Corner pixel ornaments optional.

#### `PaperCard`

Dùng cho dialogue body, notebook note, recipe detail.

- Fill: `#ead6a3`
- Text: `#3a261a`
- Border: warm brown.
- Optional stain/tape decoration generated bằng TextureRect hoặc ColorRect.

#### `ChoiceButton`

Dùng cho lựa chọn thoại và món.

States:

- normal: paper fill, brown text.
- hover/focus: amber glow, border sáng.
- pressed/selected: deeper amber fill.
- disabled: muted, opacity thấp.

#### `MoodChip`

Dùng cho mood/flavor tags.

Ví dụ text:

- `mệt`
- `ướt mưa`
- `ngập ngừng`
- `cần món ấm`
- `ấm`
- `đắng nhẹ`
- `ít ngọt`
- `no bụng`
- `kỷ niệm`

#### `PortraitFrame`

- Frame gỗ nhỏ.
- Có thể crop từ sprite/portrait nếu có.
- Nếu chưa có portrait, render enlarged sprite trong frame hoặc tạo portrait procedural/generated.

#### `MemoryNote`

- Sticky note/card giấy ở panel phải.
- Hiển thị gợi ý trí nhớ, không phải quest objective.

#### `TimeWeatherStrip`

Ví dụ:

`00:37 · Mưa vừa · Đêm 1`

Luôn nhỏ, ở góc trên phải của bottom panel hoặc top HUD rất nhẹ.

---

## 7. Màn hình cần thiết kế/implement

### 7.1. Main Menu

**Mục tiêu:** Người chơi nhìn vào hiểu ngay game là quán nhỏ sau mưa.

Layout:

- Background scene quán mưa đêm.
- Title: `Đèn Hẻm Sau Mưa`
- Subtitle: `Một quán nhỏ mở cửa sau 22:00`
- Buttons dạng card lớn, tốt nhất ở phải hoặc lower-right:
  - `Bắt đầu`
  - `Tiếp tục`
  - `Tải bản lưu`
  - `Sổ công thức`
  - `Cài đặt`
  - `Thoát`

Button nên có subtitle nhỏ:

- `Bắt đầu` — `Mở cửa đêm đầu tiên`
- `Tiếp tục` — `Quay lại ca đang dở`
- `Tải bản lưu` — `Chọn một đêm đã lưu`

Không để title/button che toàn bộ quán.

---

### 7.2. Top Gameplay Navigation

Nút nhỏ nhưng rõ:

- `Sổ ghi chép`
- `Sổ công thức`
- `Lưu`
- `Menu chính`

Không dùng nút quá bé như ảnh AI. Button height tối thiểu `36–40px`.

---

### 7.3. Dialogue Panel

Đây là màn quan trọng nhất.

Layout đề xuất:

```
┌────────────────────────────────────────────────────────────┐
│ portrait  │  dialogue paper/card                   │ note │
│ name      │  customer/narrator text                 │ hint │
│ mood tags │                                      time│      │
│           ├──────────────────────────────────────────┤      │
│           │ choice 1 | choice 2 | choice 3           │      │
└────────────────────────────────────────────────────────────┘
```

Required fields:

- Customer portrait.
- Customer name.
- Short role/mood line.
- Mood chips.
- Main dialogue line.
- 2–4 choice cards.
- Memory note/gợi ý nếu có.
- Time/weather strip.

Text style:

- Customer line: cream/paper card, warm.
- Narrator line: muted cream, italic-like if possible.
- Player choice: large buttons.
- Important clue: amber or teal highlight.

Example content:

```
Minh
ướt mưa · mệt · cần tỉnh táo

“Chị cho em món gì vừa nóng vừa đủ để chạy thêm một cuốc nữa.”

Gợi ý trí nhớ:
Minh không thích vị quá ngọt.

[Trà gừng ít đường]
[Cháo trứng]
[Cà phê phin nóng]
```

---

### 7.4. Recipe Selection / Sổ công thức trong phục vụ

Dựa mạnh vào ảnh Recipe Book.

Layout:

```
┌──────────────────────── Open Recipe Book ───────────────────────┐
│ Left page                         │ Right page                   │
│ Filter chips                      │ Selected recipe detail        │
│ Recipe cards                      │ Description                   │
│ Icon + name + tags                │ warmth/caffeine/comfort       │
│                                   │ customer hint/weather hint     │
│                                   │ [Nấu món này] [Quay lại]      │
└─────────────────────────────────────────────────────────────────┘
```

Filter chips:

- `Tất cả`
- `Đồ uống`
- `Món nóng`
- `No bụng`
- `Ít ngọt`
- `Kỷ niệm`

Recipe card:

- icon from existing animated props/Shikashi if available;
- name from `demo_content.json`;
- tags from `flavor_tags`, `emotion_tags`;
- locked/unlocked state;
- hover and selected state.

Selected detail:

- recipe name;
- description;
- `Độ ấm`;
- `Caffeine`;
- `An ủi`;
- `Gợi nhớ`;
- customer hint;
- weather hint;
- actions.

No prices, no inventory grid, no crafting table.

---

### 7.5. Cooking / Serving Panel

Mục tiêu: thêm cảm giác “chuẩn bị món” trước khi phục vụ, nhưng không biến thành arcade minigame.

Layout:

- Tray preview ở giữa.
- Left card: `Ghi nhớ về khách`.
- Right card: `Điều chỉnh nhẹ`.
- Bottom buttons:
  - `Phục vụ`
  - `Đổi món`
  - `Quay lại`

Optional adjustment choices:

- `Ít đường`
- `Nóng hơn`
- `Giữ nguyên`
- `Thêm gừng`
- `Nhẹ vị hơn`

Không có timer/score/fail state. Chỉ là một bước xúc giác, ấm, chậm.

---

### 7.6. Reaction Panel

Mục tiêu: người chơi thấy món mình chọn tạo khác biệt.

Required fields:

- Customer portrait/name.
- Mood before/after.
- Served recipe card.
- Reaction text.
- Result label cảm xúc:
  - `Không hợp lắm`
  - `Tạm ổn`
  - `Đúng lúc`
  - `Món ký ức`
- Notebook update card.
- Buttons:
  - `Tiếp tục trò chuyện`
  - `Khách tiếp theo`
  - `Mở sổ ghi chép`

Không dùng star rating, perfect combo, điểm số, tiền thưởng.

---

### 7.7. Notebook Screen

Bắt buộc tạo cảm giác quyển sổ mở.

Nếu không có asset book, tự tạo `ui_notebook_open.png` hoặc dựng bằng two `PaperCard` lớn + spine + tabs.

Tabs:

- `Khách quen`
- `Công thức`
- `Kỷ vật`
- `Những đêm mưa`
- `Ghi chú quán`

Current tab `Khách quen`:

Left page:

- list khách + portrait nhỏ.

Right page:

- tên khách;
- mô tả ngắn;
- sở thích đã biết;
- manh mối ký ức;
- món ký ức nghi ngờ;
- keepsake slot;
- ghi chú chủ quán.

Ví dụ copy đúng style:

```
Chú Bảy
Bảo vệ ca đêm. Ít nói. Hay ngồi gần cửa.

Sở thích đã biết:
• Thích món nóng.
• Không thích vị quá ngọt.
• Hay nhìn đồng hồ lúc 23:30.

Manh mối ký ức:
• Nhắc đến căn nhà cũ khi nghe tiếng nước sôi.
• Có giữ một tấm ảnh cũ trong ví.

Món có thể gợi nhớ:
Cháo trứng?

Ghi chú:
Đừng hỏi dồn. Có những chuyện cần một món nóng trước đã.
```

Không dùng English headings trong UI.

---

### 7.8. Keepsake Screen

Có thể nằm trong Notebook tab hoặc màn riêng.

Grid không được giống inventory RPG. Hãy làm như kệ nhỏ / trang sổ kỷ vật.

Kỷ vật demo:

- `ảnh cũ`
- `hoa thừa`
- `vé xe`
- `thẻ nhân viên`
- `kẹp tóc`
- `khăn tay`
- `mảnh giấy ghi món`

States:

- locked silhouette;
- half-discovered;
- unlocked with note.

---

### 7.9. End-of-Night Summary

Không dùng score. Đây là màn đóng ca.

Header:

`Khép lại Đêm 1`

Subtitle:

`04:03 · Mưa đã nhỏ dần`

Cards:

- `Khách đã ghé`
- `Món đã phục vụ`
- `Ghi chú mới`
- `Kỷ vật`
- `Mở khóa`

Buttons:

- `Sang đêm tiếp theo`
- `Mở sổ ghi chép`
- `Lưu và về menu`

---

### 7.10. Settings / Save Load

Settings phải là grouped cards, không phải debug form dài.

Groups:

- Âm thanh: Master, Music, Ambience, UI/SFX sliders.
- Hiển thị: text speed, fullscreen/windowed, pixel filter reminder.
- Gameplay: click-to-advance, auto-save.
- Sprite slice settings: giữ nếu đã có, nhưng trình bày gọn.
- Save: reset save với confirmation.

Save/load slots:

```
Đêm 3 · 00:42
Khách gần nhất: Linh
Kỷ vật: 2
Công thức mở khóa: 9/19
[Tải] [Xóa]
```

Confirmation modal:

`Bắt đầu mới sẽ ghi đè bản lưu hiện tại.`

Buttons:

- `Tiếp tục`
- `Hủy`

---

## 8. Font và text tiếng Việt

- Text phải dùng font hỗ trợ tiếng Việt.
- Nếu repo đã có font hợp lệ thì dùng.
- Nếu không có, dùng default Godot font tạm thời để đảm bảo tiếng Việt hiển thị đúng.
- Không bake text vào PNG do AI tạo, ngoại trừ logo/title nếu Codex tạo được bản đẹp và vẫn có fallback Label.
- Bật autowrap cho đoạn dài.
- Không để label clip.
- Không để chữ một ký tự một dòng.
- Ưu tiên copy ngắn, tự nhiên, có khoảng lặng.

---

## 9. Scene và UI layering

Layer order trong gameplay:

1. background wall/floor/window
2. back props
3. counter_back / tables back
4. characters
5. counter_front / table_front
6. foreground props
7. rain/steam/light fx
8. UI dim overlay nếu mở modal/book
9. UI panels
10. tooltip/modal top

QA bắt buộc:

- Quầy không che mặt player.
- Bàn không che mặt khách.
- Khách ngồi phải dùng front-facing/seated idle.
- Khách vào quán chỉ walk khi arrival, không walk lại sau mỗi nút bấm.
- UI không che mất thông tin chính.

---

## 10. Implementation plan cho Codex

### Step A — Audit

1. Scan repo structure.
2. Locate:
   - `NightCafeGame.tscn`
   - `scripts/game/night_cafe_game.gd`
   - `scripts/visual/character_sprite_controller.gd`
   - `data/demo_content.json`
   - `data/characters.json`
   - `data/sprite_slice_presets.json`
   - current assets under `res://assets/`
3. Identify current UI creation code and current state machine.
4. Do not rewrite content data unless needed for missing fields.

### Step B — Theme/UI factory

Create reusable theme/factory code:

- Colors constants.
- StyleBox helpers.
- Button style helpers.
- Chip creation.
- Paper card creation.
- Wood panel creation.
- Tab creation.
- Portrait frame creation.

### Step C — Generated UI assets

If missing, create generated UI assets in:

`res://assets/generated/ui/`

At minimum:

- notebook/open book look;
- recipe book/open book look;
- sticky note;
- tab;
- portrait frame;
- wood button frame.

Use generated assets only as decoration/background; text stays runtime.

### Step D — Main screens

Implement/refactor screens in this priority:

1. `DialoguePanel`
2. `RecipeSelectionPanel`
3. `NotebookPanel`
4. `ReactionPanel`
5. `EndNightSummaryPanel`
6. `MainMenuPanel`
7. `Settings/SaveLoadPanel`

### Step E — Data binding

Bind UI to existing content:

- customers from `data/demo_content.json`
- recipes from `data/demo_content.json`
- character config from `data/characters.json`
- save state from `user://night_cafe_demo_save.json`

No hardcoded English UI. Use Vietnamese labels.

### Step F — Responsive check

Must work at `1280x720` without clipped text.

### Step G — Test

Run Godot headless parse:

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path 'D:\GameMaking\idea-ready-game' --quit-after 1
```

Then run normal demo and test:

- main menu;
- new game;
- dialogue;
- recipe selection;
- serve reaction;
- notebook;
- recipe book;
- save/load;
- end night.

---

## 11. Acceptance checklist

Codex hoàn thành khi:

- [ ] Game boot được vào main menu.
- [ ] Main menu có mood mưa đêm, button lớn, subtitle rõ.
- [ ] Gameplay scene top 60–65%, UI panel bottom 35–40%.
- [ ] Dialogue panel có portrait/name/mood/dialogue/choices/note/time.
- [ ] Choice cards lớn, readable, hover/focus rõ.
- [ ] Recipe selection là book-like layout, list trái, detail phải.
- [ ] Recipe detail có customer hint và weather hint.
- [ ] Cooking/serving panel có preview món và action `Phục vụ`.
- [ ] Reaction panel không dùng score/star/coin; dùng result cảm xúc.
- [ ] Notebook là quyển sổ/paper tabs, toàn bộ tiếng Việt.
- [ ] Keepsake slot hiển thị được locked/unlocked.
- [ ] End-of-night summary có ghi chú mới, món đã phục vụ, unlock.
- [ ] Settings grouped cards, không phải debug form dài.
- [ ] Save/load slot có confirmation khi xóa/ghi đè.
- [ ] Text tiếng Việt không lỗi dấu, không mojibake.
- [ ] Không có label một chữ một dòng.
- [ ] Không có horizontal overflow.
- [ ] Không dùng asset 32x32 sai chuẩn.
- [ ] Không scale lẻ pixel art.
- [ ] Props animated không morph sang tile khác.
- [ ] Khách ngồi không bị bàn/quầy che mặt.
- [ ] Headless Godot pass.

---

## 12. Codex execution prompt ngắn gọn

Dán đoạn này cho Codex nếu chỉ muốn chạy một prompt:

```text
Bạn là senior Godot 4.7 developer, game UI/UX designer và pixel-art technical artist. Hãy tự phân tích repo hiện tại của game “Đèn Hẻm Sau Mưa”, sau đó nâng cấp toàn bộ UI/UX theo file design brief này.

Mục tiêu: biến demo từ prototype text UI thành vertical slice cozy indie có UI đẹp: main menu, dialogue panel, recipe selection book, cooking/serving panel, reaction panel, notebook, recipe book, keepsake, end-of-night summary, settings/save/load.

Không hỏi lại. Không phá gameplay đang chạy. Dùng assets sẵn có trước: LimeZu characters 16x16, animated objects 16x16, Shikashi icons, demo_content.json, characters.json, sprite_slice_presets.json. Nếu thiếu asset UI như quyển sách, tab giấy, frame gỗ, sticky note, keepsake slot, portrait frame thì tự tạo assets mới bằng CodexAI hoặc procedural script, lưu vào res://assets/generated/ui/ và dùng trong runtime.

Text UI phải là Label/RichTextLabel tiếng Việt có dấu, không bake chữ AI vào ảnh. UI phải readable ở 1280x720, không overflow, không one-letter-per-line. Pixel art nearest, không scale lẻ, không dùng 32x32 constants sai. Recipe UI không phải inventory RPG; reaction không dùng score/coin/star; notebook là trái tim game.

Implement theo thứ tự: UI theme/factory -> DialoguePanel -> RecipeSelectionPanel -> NotebookPanel -> ReactionPanel -> EndNightSummaryPanel -> MainMenuPanel -> Settings/SaveLoad. Bind với data thật trong demo_content.json. Cuối cùng chạy Godot headless parse và sửa mọi lỗi.
```
