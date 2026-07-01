extends Control

const DATA_PATH := "res://data/demo_content.json"
const SAVE_PATH := "user://night_cafe_demo_save.json"
const AssetCatalog := preload("res://scripts/core/asset_catalog.gd")

var data: Dictionary
var state: Dictionary
var current_night_index := 0
var current_visit_index := 0
var current_visit: Dictionary = {}
var current_choice: Dictionary = {}
var selected_menu: Array[String] = []
var menu_recipe_buttons: Dictionary = {}
var ambience_enabled := true
var rain_lines: Array[ColorRect] = []
var screen_history: Array[String] = []

var root_layer: Control
var content: VBoxContainer
var title_label: Label
var subtitle_label: Label
var top_bar: HBoxContainer

func _ready() -> void:
	data = _load_json(DATA_PATH)
	_reset_state()
	_build_shell()
	_show_main_menu()

func _process(delta: float) -> void:
	if not ambience_enabled:
		return
	for line in rain_lines:
		line.position.y += 160.0 * delta
		if line.position.y > size.y + 20.0:
			line.position.y = -20.0

func _load_json(path: String) -> Dictionary:
	var text := FileAccess.get_file_as_string(path)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Cannot parse content data: %s" % path)
		return {}
	return parsed

func _reset_state() -> void:
	state = {
		"current_night": 1,
		"unlocked_recipes": [],
		"customer_notes": {},
		"trust": {},
		"keepsakes": [],
		"completed_visits": [],
		"last_summary": [],
		"demo_completed": false
	}
	for recipe in data.get("recipes", []):
		if recipe.get("initial", false):
			state["unlocked_recipes"].append(recipe["id"])

func _build_shell() -> void:
	var bg := ColorRect.new()
	bg.color = Color("#101923")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color(0.95, 0.58, 0.23, 0.11)
	glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	glow.position = Vector2(0, 0)
	add_child(glow)

	_build_rain()
	_add_decor_sprites()

	root_layer = MarginContainer.new()
	root_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_layer.add_theme_constant_override("margin_left", 42)
	root_layer.add_theme_constant_override("margin_right", 42)
	root_layer.add_theme_constant_override("margin_top", 30)
	root_layer.add_theme_constant_override("margin_bottom", 30)
	add_child(root_layer)

	var main := VBoxContainer.new()
	main.add_theme_constant_override("separation", 14)
	root_layer.add_child(main)

	title_label = Label.new()
	title_label.text = data.get("game", {}).get("title", "Đèn Hẻm Sau Mưa")
	title_label.add_theme_font_size_override("font_size", 34)
	title_label.add_theme_color_override("font_color", Color("#ffe3ad"))
	main.add_child(title_label)

	subtitle_label = Label.new()
	subtitle_label.text = data.get("game", {}).get("subtitle", "")
	subtitle_label.add_theme_color_override("font_color", Color("#b9c7c7"))
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	main.add_child(subtitle_label)

	top_bar = HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 8)
	main.add_child(top_bar)

	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#1d2a2d"), Color("#5b3d2e")))
	main.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(scroll)

	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)

func _build_rain() -> void:
	for i in 42:
		var line := ColorRect.new()
		line.color = Color(0.55, 0.7, 0.85, 0.18)
		line.size = Vector2(2, 18 + (i % 4) * 6)
		line.position = Vector2((i * 73) % 1260, (i * 41) % 720)
		line.rotation = deg_to_rad(-8)
		add_child(line)
		rain_lines.append(line)

func _add_decor_sprites() -> void:
	var atlas := TextureRect.new()
	atlas.texture = load(AssetCatalog.MODERN_INTERIOR_GENERIC)
	atlas.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	atlas.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	atlas.modulate = Color(1, 1, 1, 0.16)
	atlas.position = Vector2(900, 80)
	atlas.size = Vector2(260, 520)
	add_child(atlas)

	var ui := TextureRect.new()
	ui.texture = load(AssetCatalog.MODERN_UI)
	ui.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ui.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	ui.modulate = Color(1, 0.87, 0.62, 0.14)
	ui.position = Vector2(42, 480)
	ui.size = Vector2(180, 180)
	add_child(ui)

func _panel_style(fill: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(18)
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_size = 8
	return style

func _clear() -> void:
	for child in content.get_children():
		child.queue_free()
	for child in top_bar.get_children():
		child.queue_free()

func _setup_top_bar(show_game_buttons := true) -> void:
	for child in top_bar.get_children():
		child.queue_free()
	if show_game_buttons:
		top_bar.add_child(_button("Sổ ghi chép", _show_notebook))
		top_bar.add_child(_button("Sổ công thức", _show_recipe_book))
		top_bar.add_child(_button("Lưu", _save_game))
	top_bar.add_child(_button("Menu chính", _show_main_menu))

func _show_main_menu() -> void:
	_clear()
	_setup_top_bar(false)
	screen_history.clear()
	_add_visual_stage()
	_add_heading("Quán đã lên đèn.")
	_add_paragraph(data.get("game", {}).get("vision", ""))
	_add_paragraph("Bản demo tập trung vào 5 đêm đầu: mở quán, lắng nghe, chọn món đúng lúc, và ghi lại những gì khách để lại.")
	content.add_child(_button("Bắt đầu demo mới", _new_game))
	var continue_button := _button("Tiếp tục từ save", _load_game)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	content.add_child(continue_button)
	content.add_child(_button("Settings", _show_settings))
	content.add_child(_button("Credits / License notes", _show_credits))

func _new_game() -> void:
	_reset_state()
	_save_game()
	_show_prep()

func _show_settings() -> void:
	_clear()
	_setup_top_bar(false)
	_add_visual_stage()
	_add_heading("Settings")
	_add_paragraph("Bản demo hiện dùng ambience thị giác thay cho audio thật. Audio sẽ được thêm sau khi loop chính ổn định.")
	var ambience_button := _button("Bật/tắt hiệu ứng mưa: %s" % ("BẬT" if ambience_enabled else "TẮT"), func():
		ambience_enabled = not ambience_enabled
		for line in rain_lines:
			line.visible = ambience_enabled
		_show_settings()
	)
	content.add_child(ambience_button)
	content.add_child(_button("Quay lại", _show_main_menu))

func _show_credits() -> void:
	_clear()
	_setup_top_bar(false)
	_add_visual_stage()
	_add_heading("Credits / License notes")
	_add_paragraph("Game demo: Đèn Hẻm Sau Mưa. Nội dung, nhân vật, bối cảnh và tuyến truyện được viết mới cho project này.")
	_add_paragraph("Asset prototype: Modern Interiors by LimeZu, Shikashi Fantasy Icons, Super Retro World by The low-res artist. Xem chi tiết trong docs/LICENSE_NOTES.md trước khi phát hành công khai.")
	content.add_child(_button("Quay lại", _show_main_menu))

func _show_prep() -> void:
	_clear()
	_setup_top_bar(true)
	current_night_index = int(state["current_night"]) - 1
	if current_night_index >= data["nights"].size():
		_show_demo_ending()
		return
	_unlock_recipes_for_current_night()
	selected_menu.clear()
	menu_recipe_buttons.clear()
	var night: Dictionary = data["nights"][current_night_index]
	_add_visual_stage()
	_add_heading("Trước khi mở quán")
	_add_meta("%s · %s" % [night["date_label"], night["weather"]])
	_add_paragraph(night["opening_text"])
	_add_subheading("Việc chuẩn bị nhẹ")
	for note in night.get("prep_notes", []):
		_add_bullet(note)
	_add_subheading("Chọn vài món nổi bật cho menu đêm nay")
	_add_paragraph("Không ảnh hưởng nặng đến điểm số; đây là nhịp chuẩn bị để bạn đọc mood của đêm.")
	var grid := GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for recipe in _available_recipes():
		var recipe_id: String = str(recipe["id"])
		var b := _button(str(recipe["name"]), func(): _toggle_menu_recipe(recipe_id))
		b.tooltip_text = recipe["description"]
		menu_recipe_buttons[recipe_id] = b
		_update_menu_recipe_button(recipe_id)
		grid.add_child(b)
	content.add_child(grid)
	_add_note("Menu đêm nay: chọn tối đa 5 món. Nếu bỏ trống, quán sẽ dọn sẵn 5 món đầu.")
	content.add_child(_button("Mở quán", _start_night))

func _toggle_menu_recipe(recipe_id: String) -> void:
	if selected_menu.has(recipe_id):
		selected_menu.erase(recipe_id)
	elif selected_menu.size() < 5:
		selected_menu.append(recipe_id)
	_update_menu_recipe_button(recipe_id)

func _start_night() -> void:
	if selected_menu.is_empty():
		for recipe in _available_recipes().slice(0, 5):
			selected_menu.append(recipe["id"])
	current_visit_index = 0
	_show_next_customer()

func _show_next_customer() -> void:
	var night: Dictionary = data["nights"][current_night_index]
	if current_visit_index >= night["visits"].size():
		_show_closing()
		return
	current_visit = night["visits"][current_visit_index]
	current_choice = {}
	_clear()
	_setup_top_bar(true)
	var customer := _customer(current_visit["customer_id"])
	_add_visual_stage(str(current_visit["customer_id"]))
	_add_heading("%s bước vào" % customer["name"])
	_add_meta("%s · %s" % [customer["short_description"], current_visit["mood"]])
	_add_paragraph(current_visit["arrival"])
	for line in current_visit.get("lines", []):
		_add_dialogue(line)
	_add_subheading("Bạn đáp lại thế nào?")
	for choice in current_visit.get("choices", []):
		var choice_data: Dictionary = choice
		content.add_child(_button(str(choice["text"]), func(): _choose_dialogue(choice_data)))

func _choose_dialogue(choice: Dictionary) -> void:
	current_choice = choice
	_add_note(choice.get("response", ""))
	if choice.has("note"):
		_add_customer_note(current_visit["customer_id"], choice["note"])
	_show_recipe_selection()

func _show_recipe_selection() -> void:
	_add_subheading("Chọn món / đồ uống")
	_add_paragraph("Hãy chọn theo lời khách, thời tiết, những gì bạn nhớ, và cảm giác của đêm.")
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for recipe in _available_recipes():
		var recipe_id: String = str(recipe["id"])
		var b := _button(_recipe_button_text(recipe), func(): _serve_recipe(recipe_id))
		b.tooltip_text = "%s\nTags: %s / %s" % [recipe["description"], ", ".join(recipe.get("flavor_tags", [])), ", ".join(recipe.get("emotion_tags", []))]
		grid.add_child(b)
	content.add_child(grid)

func _serve_recipe(recipe_id: String) -> void:
	var result := _reaction_result(recipe_id)
	var recipe := _recipe(recipe_id)
	_clear()
	_setup_top_bar(true)
	var customer := _customer(current_visit["customer_id"])
	_add_visual_stage(str(current_visit["customer_id"]), recipe_id, result)
	_add_heading("%s nhận %s" % [customer["name"], recipe["name"]])
	_add_meta("Phản ứng: %s" % _reaction_label(result))
	for line in current_visit["recipe_reactions"].get(result, current_visit["recipe_reactions"].get("bad", [])):
		_add_dialogue(line)
	for note in current_visit.get("notes_unlock", []):
		if result in ["good", "memory"]:
			_add_customer_note(current_visit["customer_id"], note)
			_add_note("Sổ ghi chép cập nhật: %s" % note)
	for recipe_unlock in current_visit.get("unlock_recipes", []):
		_unlock_recipe(recipe_unlock)
	if result == "memory":
		if current_visit.get("keepsake", "") != "":
			_add_keepsake(current_visit["keepsake"])
		elif customer.get("keepsake_item", "") != "":
			_add_keepsake(customer["keepsake_item"])
	if current_visit.get("keepsake", "") != "" and result == "good":
		_add_keepsake(current_visit["keepsake"])
	_add_trust(current_visit["customer_id"], int(current_visit.get("trust", 0)) + (2 if result == "memory" else 1 if result == "good" else 0))
	state["completed_visits"].append("%s:%s:%s" % [state["current_night"], current_visit["customer_id"], recipe_id])
	content.add_child(_button("Khách tiếp theo", func():
		current_visit_index += 1
		_show_next_customer()
	))

func _show_closing() -> void:
	_clear()
	_setup_top_bar(true)
	var night: Dictionary = data["nights"][current_night_index]
	_add_visual_stage()
	_add_heading("Sau khi đóng quán")
	_add_paragraph(night["closing_reflection"])
	_add_subheading("Dấu vết còn lại trong sổ")
	var summary: Array[String] = []
	for customer_id in state["customer_notes"].keys():
		var notes: Array = state["customer_notes"][customer_id]
		if not notes.is_empty():
			summary.append("%s: %s" % [_customer(customer_id)["name"], notes.back()])
	for line in summary.slice(max(0, summary.size() - 5), summary.size()):
		_add_bullet(line)
	state["last_summary"] = summary
	state["current_night"] = int(state["current_night"]) + 1
	_save_game()
	if int(state["current_night"]) > int(data["game"]["demo_nights"]):
		content.add_child(_button("Khép lại demo", _show_demo_ending))
	else:
		content.add_child(_button("Sang đêm tiếp theo", _show_prep))

func _show_notebook() -> void:
	_clear()
	_setup_top_bar(false)
	_add_visual_stage()
	_add_heading("Sổ ghi chép của quán")
	_add_paragraph("Không phải hồ sơ khách hàng. Chỉ là những điều quán học cách nhớ.")
	_add_subheading("Khách quen")
	for customer_id in data["customers"].keys():
		var customer: Dictionary = data["customers"][customer_id]
		_add_meta("%s · %s" % [customer["name"], customer["short_description"]])
		var notes: Array = state["customer_notes"].get(customer_id, [])
		if notes.is_empty():
			_add_bullet("Chưa có ghi chú.")
		else:
			for note in notes:
				_add_bullet(note)
	_add_subheading("Vật kỷ niệm")
	if state["keepsakes"].is_empty():
		_add_bullet("Chưa có gì ngoài vài vệt nước mưa trước cửa.")
	else:
		for item in state["keepsakes"]:
			_add_bullet(item)
	content.add_child(_button("Quay lại đêm hiện tại", _return_to_current_flow))

func _show_recipe_book() -> void:
	_clear()
	_setup_top_bar(false)
	_add_visual_stage()
	_add_heading("Sổ công thức")
	_add_paragraph("Món không chỉ là thành phần. Món còn là đúng người, đúng lúc.")
	for recipe in data["recipes"]:
		var locked: bool = not state["unlocked_recipes"].has(recipe["id"])
		var status := "ĐÃ MỞ" if not locked else "CHƯA MỞ"
		_add_meta("%s · %s · %s" % [recipe["name"], recipe["type"], status])
		if not locked:
			_add_bullet(recipe["description"])
			_add_bullet("Hương vị: %s" % ", ".join(recipe.get("flavor_tags", [])))
			_add_bullet("Cảm xúc: %s" % ", ".join(recipe.get("emotion_tags", [])))
	content.add_child(_button("Quay lại đêm hiện tại", _return_to_current_flow))

func _return_to_current_flow() -> void:
	if current_visit.is_empty():
		_show_prep()
	else:
		_show_next_customer()

func _show_demo_ending() -> void:
	state["demo_completed"] = true
	_save_game()
	_clear()
	_setup_top_bar(false)
	_add_visual_stage()
	_add_heading("Trời gần sáng")
	for line in data.get("demo_ending", []):
		_add_paragraph(line)
	content.add_child(_button("Xem sổ ghi chép lần cuối", _show_notebook))
	content.add_child(_button("Về menu chính", _show_main_menu))

func _save_game() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(state, "\t"))
		file.close()

func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		_show_main_menu()
		return
	var text := FileAccess.get_file_as_string(SAVE_PATH)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		state = parsed
		if state.get("demo_completed", false):
			_show_demo_ending()
		else:
			_show_prep()

func _unlock_recipes_for_current_night() -> void:
	for recipe in data["recipes"]:
		if int(recipe.get("unlock_night", 999)) <= int(state["current_night"]):
			_unlock_recipe(recipe["id"])

func _unlock_recipe(recipe_id: String) -> void:
	if not state["unlocked_recipes"].has(recipe_id):
		state["unlocked_recipes"].append(recipe_id)

func _available_recipes() -> Array:
	var out := []
	for recipe in data["recipes"]:
		if state["unlocked_recipes"].has(recipe["id"]):
			out.append(recipe)
	return out

func _reaction_result(recipe_id: String) -> String:
	if current_visit.get("memory_recipe", "") == recipe_id:
		return "memory"
	if current_visit.get("good_recipes", []).has(recipe_id):
		return "good"
	if current_visit.get("okay_recipes", []).has(recipe_id):
		return "okay"
	return "bad"

func _reaction_label(result: String) -> String:
	match result:
		"memory":
			return "món ký ức"
		"good":
			return "đúng lúc"
		"okay":
			return "tạm ổn"
		_:
			return "không hợp đêm nay"

func _customer(customer_id: String) -> Dictionary:
	return data["customers"].get(customer_id, {})

func _recipe(recipe_id: String) -> Dictionary:
	for recipe in data["recipes"]:
		if recipe["id"] == recipe_id:
			return recipe
	return {}

func _add_customer_note(customer_id: String, note: String) -> void:
	if not state["customer_notes"].has(customer_id):
		state["customer_notes"][customer_id] = []
	if not state["customer_notes"][customer_id].has(note):
		state["customer_notes"][customer_id].append(note)

func _add_keepsake(item: String) -> void:
	if item != "" and not state["keepsakes"].has(item):
		state["keepsakes"].append(item)

func _add_trust(customer_id: String, amount: int) -> void:
	state["trust"][customer_id] = int(state["trust"].get(customer_id, 0)) + amount

func _add_visual_stage(customer_id := "", recipe_id := "", result := "") -> void:
	var stage := PanelContainer.new()
	stage.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stage.add_theme_stylebox_override("panel", _panel_style(Color("#182426"), Color("#8f6a45")))
	content.add_child(stage)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	stage.add_child(margin)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(row)

	var room := PanelContainer.new()
	room.custom_minimum_size = Vector2(310, 136)
	room.add_theme_stylebox_override("panel", _panel_style(Color("#2a211d"), Color("#6f4e35")))
	row.add_child(room)

	var room_margin := MarginContainer.new()
	room_margin.add_theme_constant_override("margin_left", 12)
	room_margin.add_theme_constant_override("margin_right", 12)
	room_margin.add_theme_constant_override("margin_top", 10)
	room_margin.add_theme_constant_override("margin_bottom", 10)
	room.add_child(room_margin)

	var props := GridContainer.new()
	props.columns = 4
	props.add_theme_constant_override("h_separation", 12)
	props.add_theme_constant_override("v_separation", 8)
	room_margin.add_child(props)
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_candle_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_coffee_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_cat_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_cuckoo_clock_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_kitchen_pan_with_omelette_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_kitchen_oven_2cookers_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_sink_32x32.png", Vector2(54, 54)))
	props.add_child(_asset_texture_rect(AssetCatalog.MODERN_ANIMATED_DIR + "animated_toaster_32x32.png", Vector2(54, 54)))

	var details := VBoxContainer.new()
	details.add_theme_constant_override("separation", 6)
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(details)

	if customer_id != "":
		var customer := _customer(customer_id)
		var customer_row := HBoxContainer.new()
		customer_row.add_theme_constant_override("separation", 12)
		details.add_child(customer_row)
		customer_row.add_child(_asset_texture_rect(_customer_sprite_path(customer_id), Vector2(96, 96)))

		var customer_text := VBoxContainer.new()
		customer_text.add_theme_constant_override("separation", 5)
		customer_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		customer_row.add_child(customer_text)
		customer_text.add_child(_stage_label(str(customer.get("name", "Khách ghé quán")), Color("#ffe3ad"), 20))
		customer_text.add_child(_stage_label(str(customer.get("visual_hint", "Một vị khách ngồi dưới ánh đèn vàng.")), Color("#c7d7d1"), 14))
		customer_text.add_child(_stage_label("Độ quen: %s" % int(state.get("trust", {}).get(customer_id, 0)), Color("#a8c8b4"), 13))
	else:
		details.add_child(_stage_label("Góc quán lúc nửa đêm", Color("#ffe3ad"), 20))
		details.add_child(_stage_label("Đèn vàng, quầy gỗ, mèo nằm gần cửa. Ngoài hẻm vẫn còn tiếng mưa và xe máy xa xa.", Color("#c7d7d1"), 14))

	if recipe_id != "":
		var recipe := _recipe(recipe_id)
		var recipe_row := HBoxContainer.new()
		recipe_row.add_theme_constant_override("separation", 10)
		details.add_child(recipe_row)
		recipe_row.add_child(_asset_texture_rect(_recipe_sprite_path(recipe), Vector2(54, 54)))

		var recipe_text := VBoxContainer.new()
		recipe_text.add_theme_constant_override("separation", 3)
		recipe_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		recipe_row.add_child(recipe_text)
		recipe_text.add_child(_stage_label(str(recipe.get("name", "Món vừa dọn")), Color("#ffd58a"), 16))
		recipe_text.add_child(_stage_label("Phản ứng: %s" % _reaction_label(result), Color("#b8d7c5"), 13))
	elif not state.get("keepsakes", []).is_empty():
		var keepsakes: Array = state.get("keepsakes", [])
		details.add_child(_stage_label("Vật kỷ niệm mới nhất: %s" % str(keepsakes.back()), Color("#d6b98a"), 13))

func _asset_texture_rect(path: String, target_size: Vector2, region := Rect2(0, 0, 32, 32), use_region := true) -> TextureRect:
	var rect := TextureRect.new()
	rect.custom_minimum_size = target_size
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.modulate = Color(1, 0.95, 0.84, 1)
	if use_region:
		rect.texture = _atlas_texture(path, region)
	else:
		rect.texture = AssetCatalog.load_texture(path)
	return rect

func _atlas_texture(path: String, region: Rect2) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = AssetCatalog.load_texture(path)
	atlas.region = region
	return atlas

func _stage_label(text: String, color: Color, font_size := 14) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _customer_sprite_path(customer_id: String) -> String:
	match customer_id:
		"tai_xe":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Adam_phone_32x32.png"
		"van_phong":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Amelia_reading_32x32.png"
		"bao_ve":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Old_man_Josh_32x32.png"
		"sinh_vien":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Samuel_phone_32x32.png"
		"ban_hoa":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Old_woman_Jenny_32x32.png"
		"cap_doi":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Lucy_32x32.png"
		"y_ta":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Cleaner_girl_32x32.png"
		"dev":
			return AssetCatalog.MODERN_CHARACTER_DIR + "Rob_phone_32x32.png"
		_:
			return AssetCatalog.MODERN_PLAYER_ADAM

func _recipe_sprite_path(recipe: Dictionary) -> String:
	var name := str(recipe.get("name", "")).to_lower()
	var base := str(recipe.get("base", "")).to_lower()
	if base.contains("cà phê") or name.contains("cà phê") or name.contains("bạc xỉu"):
		return AssetCatalog.MODERN_ANIMATED_DIR + "animated_coffee_32x32.png"
	if name.contains("trà") or name.contains("sữa") or name.contains("cacao"):
		return AssetCatalog.MODERN_ANIMATED_DIR + "animated_coffee_32x32.png"
	if name.contains("bánh mì"):
		return AssetCatalog.MODERN_ANIMATED_DIR + "animated_toaster_32x32.png"
	return AssetCatalog.MODERN_ANIMATED_DIR + "animated_kitchen_pan_with_omelette_32x32.png"

func _recipe_button_text(recipe: Dictionary) -> String:
	var warmth := int(recipe.get("warmth_level", 0))
	var caffeine := int(recipe.get("caffeine_level", 0))
	var comfort := int(recipe.get("comfort_level", 0))
	return "%s ấm %s | tỉnh %s | dịu %s" % [recipe.get("name", "Món"), warmth, caffeine, comfort]

func _update_menu_recipe_button(recipe_id: String) -> void:
	if not menu_recipe_buttons.has(recipe_id):
		return
	var recipe := _recipe(recipe_id)
	if recipe.is_empty():
		return
	var button := menu_recipe_buttons[recipe_id] as Button
	if button == null:
		return
	var prefix := "[x] " if selected_menu.has(recipe_id) else "[ ] "
	button.text = "%s%s" % [prefix, recipe.get("name", recipe_id)]

func _button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_color_override("font_color", Color("#ffe8c2"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#3a2b24")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#5a3d2d")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#7a4d31")))
	button.pressed.connect(callable)
	return button

func _button_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color("#8f6a45")
	style.set_border_width_all(1)
	style.set_corner_radius_all(10)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style

func _add_heading(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 26)
	label.add_theme_color_override("font_color", Color("#ffd58a"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_subheading(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 19)
	label.add_theme_color_override("font_color", Color("#f4c27a"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_meta(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color("#9fb8b4"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_paragraph(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override("font_color", Color("#e8ddd0"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_dialogue(text: String) -> void:
	var label := Label.new()
	label.text = "“%s”" % text
	label.add_theme_font_size_override("font_size", 17)
	label.add_theme_color_override("font_color", Color("#fff1d6"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_note(text: String) -> void:
	var label := Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color("#b8d7c5"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(label)

func _add_bullet(text: String) -> void:
	_add_paragraph("• %s" % text)
