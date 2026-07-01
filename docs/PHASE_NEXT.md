# Phase Next - Public Demo Polish

## Mục tiêu

Nâng vertical slice hiện tại từ bản chơi được nội bộ lên bản public demo ngắn, có không khí rõ ràng, ít lỗi flow, và đủ sức trình diễn concept "quán nhỏ mở sau 22:00".

## Hiện trạng đã có

- Demo chơi được từ main menu đến ending qua 5 đêm.
- Nội dung tiếng Việt nằm trong `data/demo_content.json`.
- 5 khách chính, 3 khách vãng lai, 19 công thức.
- Dialogue choice, recipe reaction, notebook, recipe book, keepsake, save/load.
- Visual stage đã dùng asset thật từ `assets/art/modern_interiors`: prop quán, mèo, cà phê, bếp, avatar khách.

## Phase 2 Scope

1. Presentation polish
- Dựng scene quán rõ hơn bằng tilemap hoặc layout sprite thay vì chỉ panel UI.
- Thêm portrait crop riêng cho từng khách ở dialogue box.
- Thêm trạng thái visual cho món vừa phục vụ: đồ uống, món nóng, món no bụng.
- Thêm animation nhẹ: steam, đèn nhấp, mèo cử động, mưa sau cửa.

2. Dialogue UX
- Chuyển từ hiển thị toàn bộ đoạn thoại sang click-to-advance.
- Tách narrator, customer line, player choice thành style riêng.
- Thêm log hội thoại ngắn trong notebook.
- Làm lựa chọn "im lặng" có feedback rõ hơn.

3. Audio
- Thêm ambience mưa loop, chuông cửa, tiếng ly, tiếng nước sôi.
- Thêm 2-3 track nhạc nền nhẹ unlock theo đêm.
- Thêm volume sliders trong settings.

4. Content polish
- Rà lại toàn bộ thoại cho tự nhiên hơn, bớt giải thích.
- Làm tuyến Chú Bảy có một khoảnh khắc ký ức rõ hơn ở cuối demo.
- Thêm 1 liên kết nhỏ giữa Linh và Minh, 1 liên kết giữa cô Hạnh và Chú Bảy.
- Thêm phản ứng riêng cho một vài món "không hợp nhưng khách vẫn lịch sự".

5. Save/load
- Thêm confirmation khi new game ghi đè save.
- Lưu cả vị trí flow hiện tại nếu người chơi save giữa lượt khách.
- Thêm reset save trong settings.

## Tiêu chí nghiệm thu phase 2

- Người chơi nhìn màn hình là hiểu đây là quán đêm, không phải prototype text UI.
- Có audio ambience cơ bản và mute/volume hoạt động.
- Có thể chơi từ đầu đến cuối không cần đọc hướng dẫn ngoài game.
- Notebook thể hiện rõ tiến triển cảm xúc của từng khách.
- Ít nhất một đoạn memory dish tạo khác biệt rõ về thoại, vật kỷ niệm và trạng thái quán.
- Headless Godot không báo lỗi, và bản build desktop chạy được.

## Việc không làm trong phase 2

- Không thêm combat, level, quest log kiểu RPG.
- Không thêm quản lý tiền/nâng cấp nặng.
- Không mở map thành phố rộng.
- Không thêm farming hoặc crafting phức tạp.

## Cách chạy kiểm thử hiện tại

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --path 'D:\GameMaking\idea-ready-game'
```

Kiểm tra parse/headless:

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path 'D:\GameMaking\idea-ready-game' --quit-after 1
```
