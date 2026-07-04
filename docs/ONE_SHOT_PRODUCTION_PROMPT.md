# Đèn Hẻm Sau Mưa - One-Shot Production Prompt

Bạn là senior Godot 4.7 developer + game UI/UX designer + game director + senior game polish engineer.

Nhiệm vụ của bạn là tự đọc repo hiện tại của game `Đèn Hẻm Sau Mưa`, hiểu đầy đủ kiến trúc đang có, rồi triển khai thẳng một mạch đến bản production release. Không dừng ở plan. Không chỉ dừng ở demo. Không hỏi lại trừ khi thật sự bị khóa bởi thông tin không thể suy ra từ repo.

Mục tiêu cuối cùng:
- Game phải thành một cozy narrative production release hoàn chỉnh.
- Game phải có thể chơi từ đầu đến cuối, có cảm xúc, có hệ thống, có content mở rộng, có polish, có QA.
- UI phải đẹp, đúng mood, đúng pixel art, đúng open-book modal, không prototype, không debug look.

## 1. Vision

`Đèn Hẻm Sau Mưa` là game cozy narrative về một quán ăn/quán cafe đêm trong thành phố Việt Nam hư cấu. Người chơi không cứu thế giới, không combat, không farming, không quest kiểu phiêu lưu, không quản lý kinh doanh nặng.

Trọng tâm của game:
- Mở quán lúc đêm muộn.
- Pha và nấu món đúng lúc.
- Lắng nghe khách kể chuyện.
- Ghi nhớ chi tiết nhỏ.
- Tạo một nơi trú ẩn tinh thần cho những người cô đơn.

Tông cảm xúc:
- Ấm.
- Lặng.
- Hơi buồn nhưng không tuyệt vọng.
- Đời thường.
- Chậm rãi.
- Có khoảng lặng.

Ba trụ cột:
- Quán nhỏ có linh hồn.
- Món ăn và đồ uống có ý nghĩa cảm xúc.
- Nhân vật nói chuyện như người thật, không giáo điều, không sáo rỗng.

## 2. Production Scope

Game production phải gồm:
- Main Menu.
- Settings.
- Save/Load.
- Cafe scene chính.
- Recipe Book modal open-book.
- Notebook modal open-book.
- Dialogue flow.
- Cooking / serving flow.
- End of night summary.
- Credits / release notes / license notes.
- Full progression từ đầu đến cuối.

Target release content:
- 20-30 đêm nội dung.
- 8-10 khách chính.
- 12-18 khách vãng lai.
- 45-60 công thức.
- 25-35 món ký ức.
- Nhiều đêm đặc biệt theo thời tiết, mùa, sự kiện thành phố.
- Ít nhất 1 ending chính.
- Ít nhất 2 epilogue cho các arc lớn.

## 3. Mandatory UI Requirement

Recipe Book và Notebook phải là `open-book modal` đúng nghĩa.

Yêu cầu bắt buộc:
- Book nằm nổi giữa màn hình.
- Book chiếm khoảng 60-70% chiều rộng và 55-68% chiều cao ở 1280x720.
- Cafe scene phía sau vẫn thấy được qua dim overlay.
- Bottom gameplay panel cũ phải bị ẩn, mờ, hoặc khóa input khi book mở.
- Z-index của book overlay phải cao hơn toàn bộ scene và UI thường.
- Tuyệt đối không render sách như widget bị nhét xuống bottom panel cũ.

Recipe Book:
- Trang trái là danh sách món.
- Trang phải là chi tiết món đang chọn.
- Có nút `Nấu món này`.
- Có nút `Quay lại trò chuyện`.
- Nếu món nhiều, list phải nằm trong `ScrollContainer` nội bộ.
- Mọi text dài phải wrap theo từ.
- Không để list đè lên artwork của quyển sách.

Notebook:
- Là một quyển sổ mở lớn ở giữa màn hình.
- Có tab:
  - `Khách quen`
  - `Công thức`
  - `Kỷ vật`
  - `Những đêm mưa`
  - `Ghi chú quán`
- Nội dung nằm gọn trong trang giấy.
- Nếu text dài, dùng scroll nội bộ hoặc rút gọn hiển thị.
- Notebook copy phải giống ghi chú của chủ quán, không giống UI debug.

UI rules:
- Không để text tràn khỏi khung.
- Không để list chồng lên art quyển sách.
- Không để title/label nằm lệch hoặc đè lên mép sách.
- Không để chữ một ký tự một dòng.
- Không có horizontal overflow.
- Mọi content trong book phải nằm trong `MarginContainer + VBoxContainer/HBoxContainer`.
- Padding page tối thiểu:
  - top 28-36px
  - left/right 24-32px
  - bottom 24-32px
- Recipe row min height 52-72px.
- Icon fixed width.
- Label co giãn.
- Tag không đè lên tên món.
- Action buttons cách text block ít nhất 16-24px.

Nếu repo chưa có asset open-book đúng mood:
- Tự tạo asset mới vào `res://assets/generated/ui/`.
- Tối thiểu cần:
  - `ui_recipe_book_open.png`
  - `ui_notebook_open.png`
  - `ui_tab_paper.png`
  - `ui_note_sticky.png`
  - `ui_button_wood.png`
  - `ui_portrait_frame.png`
- Không bake chữ vào PNG.
- Text phải render runtime bằng `Label` / `RichTextLabel`.
- Pixel art phải nearest, không scale lẻ.

## 4. Content Bible

### 4.1 Core Customer Roster
Danh sách khách chính nên bao gồm:
- Minh, tài xế công nghệ chạy đêm.
- Linh, nhân viên văn phòng vừa nghỉ việc.
- Chú Bảy, bảo vệ ca đêm.
- An, sinh viên làm đồ án / thức khuya.
- Cô Hạnh, người bán hoa đêm.
- Mai, y tá trực đêm.
- Khoa, lập trình viên / game developer mất ngủ.
- Hùng, người cha làm ca khuya.
- Vy, ca sĩ phòng trà hết thời.
- Duy, thợ sửa xe đêm.
- Bà Năm, người sống một mình trong khu hẻm cũ.
- Tùng, sinh viên năm cuối đang mắc giữa đi làm và giữ ước mơ.

### 4.2 Customer Arc Rules
Mỗi khách chính cần:
- Tên.
- Tuổi tương đối.
- Nghề nghiệp hoặc bối cảnh sống.
- Cách nói chuyện.
- Món thường gọi.
- Món ký ức.
- Điều họ che giấu.
- Arc cảm xúc qua nhiều đêm.
- Một chi tiết nhỏ dễ nhớ.
- Một vật kỷ niệm có thể để lại.

Arc cảm xúc nên đi theo kiểu:
- Mở đầu lảng tránh.
- Giữa arc hé lộ manh mối.
- Cuối arc có một khoảnh khắc chạm ký ức hoặc chấp nhận.
- Không phải lúc nào cũng có happy ending sạch sẽ.
- Không biến chủ quán thành người “chữa lành” khách.

### 4.3 Customer Detail Pack
Minh:
- Tài xế công nghệ chạy đêm.
- Gọi cà phê đen nhiều đêm liên tiếp.
- Mạch arc: gồng mình -> mệt -> chậm lại -> dám nhận ra mình không phải máy.
- Món ký ức: cà phê đen không đường vào đêm mưa đầu tiên anh lái xe về nhà sau một lần lạc đường.
- Kỷ vật: móc khóa nhỏ hoặc tờ giấy ghi số điện thoại khách quen.

Linh:
- Nhân viên văn phòng vừa nghỉ việc.
- Bề ngoài bình tĩnh, bên trong trống rỗng và tự trách.
- Mạch arc: trống rỗng -> tự trách -> nhớ ước mơ cũ -> bình tâm bắt đầu lại.
- Món ký ức: trà hoa cúc mật ong hoặc cacao nóng.
- Kỷ vật: name card cũ bị gập.

Chú Bảy:
- Bảo vệ ca đêm, ít nói, hay nhìn đồng hồ.
- Mạch arc: lặng lẽ -> hé mở -> đối diện nỗi nhớ -> để lại một thứ cho quán.
- Món ký ức: cháo trắng trứng, hành, tiêu.
- Kỷ vật: ảnh cũ, khăn tay, hoặc bật lửa nhỏ.

An:
- Sinh viên làm đồ án, nói nhanh, hoảng nhẹ, tự ti.
- Mạch arc: hoảng -> so sánh -> tự ti -> hiểu rằng làm vì mình mới là đủ.
- Món ký ức: bạc xỉu, mì trứng, sữa đậu nành nóng.
- Kỷ vật: USB, giấy note bản vẽ, hoặc bút gãy nắp.

Cô Hạnh:
- Người bán hoa đêm, dịu dàng nhưng mỏi.
- Mạch arc: khách ghé -> khách quen -> người gắn bó với quán -> mang hoa cho quán.
- Món ký ức: trà sen đêm mưa, chanh muối ấm.
- Kỷ vật: lọ hoa nhỏ, cành hoa khô, hoặc bưu thiếp.

Mai:
- Y tá trực đêm.
- Mạch arc: chăm người khác -> quên chăm mình -> dừng lại một chút -> học cách nhận sự chăm sóc.
- Món ký ức: súp nóng rau thơm, sữa nóng mật ong.
- Kỷ vật: nhãn tên, dây buộc tóc, hoặc huy hiệu nhỏ.

Khoa:
- Lập trình viên / game developer mất ngủ.
- Mạch arc: lý trí hóa mọi thứ -> cười cho qua -> chạm vào mệt mỏi thật -> chấp nhận ngủ.
- Món ký ức: cà phê sữa, cacao nóng, bánh mì chảo nhỏ.
- Kỷ vật: thẻ ra vào công ty, sticker laptop, note dán lỗi.

Hùng:
- Người cha làm ca khuya, mua đồ ăn về cho con.
- Mạch arc: lặng lẽ chịu đựng -> nhớ con -> nhận ra mình cũng cần được hỏi han.
- Món ký ức: mì bò ít cay, cháo hành tiêu thật nhẹ.
- Kỷ vật: hộp cơm nhỏ, vỏ kẹo con để lại.

Vy:
- Ca sĩ phòng trà cũ, giọng vẫn hay nhưng ít hát.
- Mạch arc: tự xem mình đã qua thời -> nhớ lại sân khấu -> chấp nhận một đời khác.
- Món ký ức: trà đào ít ngọt, cà phê sữa.
- Kỷ vật: vé hát cũ, miếng gẩy đàn, tờ setlist.

Duy:
- Thợ sửa xe đêm, dính dầu mỡ, nói ít.
- Mạch arc: cơ thể mệt, tay đau -> ngồi lâu hơn -> bắt đầu kể về người đã từng chờ mình.
- Món ký ức: mì nóng, trà gừng mật ong.
- Kỷ vật: con ốc cũ, khăn lau tay.

Bà Năm:
- Sống một mình lâu, quen ăn ít.
- Mạch arc: không muốn làm phiền -> bắt đầu nói chuyện với quán -> để quán thành thói quen.
- Món ký ức: cháo trắng, trứng, hành phi.
- Kỷ vật: khuy áo cũ, giấy ghi thuốc, hoặc ảnh cháu.

Tùng:
- Sinh viên năm cuối, mắc giữa đi làm và giữ ước mơ.
- Mạch arc: đứng giữa -> sợ chọn sai -> nhận ra sống là chọn tiếp tục.
- Món ký ức: bánh mì chảo, sữa đậu nành, trà nóng ít ngọt.
- Kỷ vật: thư mời phỏng vấn, bản nháp CV.

### 4.4 Wanderer Customers
Các khách vãng lai nên gồm:
- Một cặp đôi sắp chia tay nhưng vẫn gọi chung một món.
- Một du khách lạc đường.
- Một ca sĩ phòng trà hết thời ghé một đêm.
- Một người mẹ mua đồ ăn mang về cho con.
- Một chú xe ôm già thích ngồi gần cửa.
- Một cô gái vừa thất tình nhưng không muốn nói.
- Một anh nhân viên giao hàng đứng ngoài cửa rất lâu.
- Một ông chú xem tin tức khuya, nói rất ít.

### 4.5 Writing Rules
- Tiếng Việt tự nhiên, câu ngắn, có khoảng lặng.
- Im lặng phải có giá trị.
- Không biến chủ quán thành nhà trị liệu.
- Không dùng quest language kiểu “hãy giúp tôi”.
- Không chốt arc bằng happy ending sạch sẽ.
- Không để thoại quá văn vẻ.
- Không để mọi nhân vật đều nói giống nhau.

## 5. Recipe And Food System

### 5.1 Recipe Structure
Mỗi món nên có:
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
- `unlock_condition`

### 5.2 Core Food Groups
- Cà phê.
- Trà.
- Sữa.
- Cacao.
- Cháo.
- Mì.
- Cơm.
- Bánh mì.
- Súp.

### 5.3 Flavor And Emotion Tags
Flavor:
- Đắng.
- Ngọt.
- Béo.
- Cay nhẹ.
- Mặn.
- Thanh.
- Chua dịu.

Emotion:
- An ủi.
- Hoài niệm.
- Thức tỉnh.
- Thư giãn.
- Nhớ nhà.
- Bình tâm.
- Can đảm.
- Chấp nhận.

### 5.4 Ingredients
- Gừng.
- Mật ong.
- Trứng.
- Tiêu.
- Hành.
- Sữa đặc.
- Đậu nành.
- Quế.
- Chanh muối.
- Rau thơm.
- Nước dùng.
- Tỏi phi.
- Vừng.
- Ớt bột nhẹ.

### 5.5 Important Recipe Sets
Món tỉnh táo:
- Cà phê đen nóng.
- Cà phê sữa đậm.
- Bạc xỉu ấm.
- Trà đen hoặc trà gừng.

Món an ủi:
- Sữa nóng mật ong.
- Cacao nóng.
- Cháo trắng trứng.
- Súp nóng rau thơm.

Món nhớ nhà:
- Mì trứng.
- Cơm rang trứng.
- Bánh mì chảo nhỏ.
- Cháo hành tiêu thật nhẹ.

Món dịu xuống:
- Trà hoa cúc mật ong.
- Trà sen ấm.
- Chanh muối ấm.
- Sữa đậu nành nóng.

Món theo mưa:
- Trà sen đêm mưa.
- Cháo nóng ít gia vị.
- Mì bò ít cay.

Món ký ức:
- Công thức đặc biệt chỉ mở khi đủ manh mối.
- Món bình dân nhưng đúng người, đúng lúc.

## 6. Memory Dish System

- Mỗi khách có 1 đến 3 món ký ức.
- Món ký ức không phải món ngon nhất.
- Món ký ức là món “đúng đêm đó”.
- Món ký ức phải mở dần qua nhiều manh mối.
- Khi mở đúng, khách phản ứng đặc biệt.
- Có thể mở:
  - ghi chú mới
  - câu thoại sâu hơn
  - kỷ vật
  - trang notebook đặc biệt
  - công thức mới

Món ký ức nên tạo cảm giác:
- Người chơi nhớ ra điều khách từng nói.
- Khách nhận ra mình được lắng nghe.
- Không giải quyết toàn bộ nỗi buồn.
- Chỉ làm một vết sần trong lòng dịu xuống.

## 7. Night Structure

### 7.1 Per-Night Structure
Mỗi đêm có:
- `weather`
- `ambience`
- `opening_text`
- `customers`
- `special_event`
- `closing_reflection`

### 7.2 Night Progression
- Đêm 1-3: giới thiệu quán, khách chính, nhịp lắng nghe.
- Đêm 4-7: khách quay lại, lộ dần thói quen gọi món.
- Đêm 8-12: các arc bắt đầu giao nhau.
- Đêm 13-18: món ký ức, kỷ vật, những điều chưa nói.
- Đêm 19-24: thành phố đổi nhịp, đêm đặc biệt xuất hiện.
- Đêm 25-30: tổng hòa, epilogue, quán trở thành nơi được nhớ.

### 7.3 Special Night Types
- Đêm mưa to.
- Đêm mất điện.
- Đêm yên đến lạ.
- Đêm quán đông hơn bình thường.
- Đêm cuối tháng.
- Đêm trước lễ.
- Đêm sau một tin buồn của thành phố.
- Đêm radio phát bài cũ.
- Đêm khách cũ quay lại sau thời gian dài.
- Đêm quán đóng muộn hơn mọi khi.
- Đêm đầu tiên của một người mới.
- Đêm một khách không gọi món.

## 8. Notebook Content

Notebook không phải inventory. Notebook là ký ức tích lũy của quán.

Tab đề xuất:
- Khách quen.
- Công thức.
- Kỷ vật.
- Những đêm mưa.
- Ghi chú quán.

Nội dung notebook:
- Ghi những lần ghé.
- Ghi thói quen gọi món.
- Ghi câu nói lặp lại.
- Ghi món ký ức đã mở.
- Ghi vật khách để lại.
- Ghi những đêm đặc biệt.
- Ghi chú quán do chủ quán tự viết.

Rule:
- Notebook phải phản ánh tiến triển cảm xúc.
- Có trang bí mật mở khi đủ manh mối.
- Không để notebook trông như UI debug.
- Không để notebook thành danh sách khô cứng.

## 9. Progression System

Không dùng XP.

Tiến trình dựa trên:
- Độ quen của khách.
- Độ nhớ của quán.
- Số món ký ức đã mở.
- Số kỷ vật đã giữ.
- Số đêm đặc biệt đã đi qua.

Quán càng hiểu người hơn:
- Dialogue choices càng tinh tế.
- Một số lựa chọn im lặng trở nên mạnh hơn.
- Một số món được gợi ý tự nhiên hơn.
- Notebook hiển thị rõ hơn những điều đã tích lũy.

## 10. World And Atmosphere

Quán là một nhân vật.

Quán nên thay đổi rất nhẹ sau mỗi đêm:
- Lọ hoa mới.
- Cốc mới.
- Sticky note mới.
- Đèn ấm hơn.
- Radio đổi bài.
- Mèo đổi chỗ.
- Một bức ảnh nhỏ xuất hiện.
- Một vật kỷ niệm được đặt lên kệ.

City atmosphere:
- Khu văn phòng.
- Khu bệnh viện.
- Khu chung cư cũ.
- Hẻm chợ đêm.
- Bãi xe.
- Trạm xe.
- Phòng trà.
- Cửa hàng sửa xe.

Không cần map lớn. Chỉ cần cảm giác thành phố đang sống ngoài khung hình.

## 11. UI And Visual Style

Phong cách:
- Pixel art 16x16 thống nhất.
- Nearest filter.
- Mipmaps off.
- Repeat disabled.
- Không scale lẻ.
- Không crop sai frame.
- Không animate cả atlas.
- Không dùng placeholder blocky.

Scene layers:
- background / wall
- floor
- back props
- counter_back
- characters
- counter_front
- props_front
- fx
- UI

UI mood:
- Gỗ nâu.
- Amber.
- Parchment.
- Worn paper.
- Cozy indie.
- Không hiện đại bóng bẩy.
- Không neon.

## 12. Audio Direction

Ambience:
- Rain loop.
- Fan hum.
- Motorcycle far away.
- Door bell.
- Cup clink.
- Spoon stir.

Cooking:
- Pour.
- Stir.
- Boil.
- Serve.

UI:
- Soft click.
- Page turn.
- Wood tap.

Music:
- Lofi đêm.
- Jazz nhẹ.
- Acoustic tối giản.

## 13. Technical Constraints

- Game phải data-driven.
- Không hardcode content trong logic nếu có thể tránh.
- Không dùng 32x32 constants sai cho scene 16x16.
- `sprite_slice_presets.json` phải là nguồn chính cho slice settings.
- Save/load phải có version.
- Có migration nếu schema đổi.
- Không phá flow demo hiện có.

## 14. Production QA Requirements

Test thủ công:
- Mở game.
- New game.
- Bấm `Sổ công thức` thấy open-book modal ở giữa màn hình.
- Text/list/detail nằm gọn trong quyển sách.
- Bấm `Quay lại trò chuyện` đóng overlay đúng.
- Bấm `Sổ ghi chép` thấy notebook open-book modal.
- Không còn text tràn.
- Không còn chồng khung.
- Không còn lệch layout.
- Không còn một ký tự một dòng.
- Không crash.

Smoke tests:
- Boot to menu.
- Open/close recipe book.
- Open/close notebook.
- Start night.
- Serve one customer.
- Close night.
- Save/load.
- Headless parse phải sạch lỗi nghiêm trọng.

## 15. Production Milestones

Milestone A:
- Modal book UI đúng chuẩn.
- Text layout sạch.
- Overlay khóa input đúng.

Milestone B:
- Full content backbone.
- Customers / recipes / nights / notebook data-driven.

Milestone C:
- World polish.
- Layering.
- Animation state.
- Sprite slicing consistency.

Milestone D:
- Audio integration.
- Technical hardening.
- Save/load migration.

Milestone E:
- QA.
- Release candidate.
- Desktop build.
- Release notes.

## 16. Acceptance Criteria

Game chỉ được coi là hoàn thành production khi:
- Recipe Book là open-book modal giữa màn hình.
- Notebook là open-book modal giữa màn hình.
- Không còn widget sách bị nhét dưới panel.
- Không còn overflow text.
- Không còn UI lệch.
- Nội dung đủ sâu để chơi tới cuối.
- Các arc khách có mở đầu, giữa, và một dạng kết thúc.
- Quán có cảm giác tích lũy ký ức.
- Game chạy từ đầu đến cuối không crash.
- Không có lỗi parse/runtime nghiêm trọng.
- Content đủ để phát hành production.

## 17. Explicit Instruction To The Implementing Agent

Khi đọc file này, hãy:
- Tự audit repo trước.
- Tự tìm file và hệ thống đang có.
- Tự thực thi toàn bộ phần cần làm.
- Không dừng ở plan.
- Không hỏi lại trừ khi thật sự bị chặn.
- Ưu tiên hoàn thiện vertical slice thành production-ready release.
- Giữ đúng tone cozy narrative của game.
- Không tạo placeholder xấu nếu có thể dùng asset gốc hoặc tạo asset đúng style bằng pipeline hợp lệ.

