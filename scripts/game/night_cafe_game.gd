extends Control

const DATA_PATH := "res://data/demo_content.json"
const CHARACTER_DATA_PATH := "res://data/characters.json"
const SAVE_PATH := "user://night_cafe_demo_save.json"
const AssetCatalog := preload("res://scripts/core/asset_catalog.gd")
const CharacterSpriteController := preload("res://scripts/visual/character_sprite_controller.gd")
const SCENE_WIDTH := 1280.0
const SCENE_HEIGHT := 410.0

var data: Dictionary
var character_data: Dictionary
var state: Dictionary
var current_night_index := 0
var current_visit_index := 0
var current_visit: Dictionary = {}
var current_choice: Dictionary = {}
var selected_menu: Array[String] = []
var menu_recipe_buttons: Dictionary = {}
var ambience_enabled := true
var rain_lines: Array[ColorRect] = []
var steam_lines: Array[ColorRect] = []
var lamp_glows: Array[ColorRect] = []
var scene_time := 0.0
var walking_customer: CharacterSpriteController
var walking_customer_state := "idle"
var walking_path: Array[Vector2] = []
var walking_target_index := 0
var screen_history: Array[String] = []

var root_layer: Control
var scene_layer: Control
var content: VBoxContainer
var title_label: Label
var subtitle_label: Label
var top_bar: HBoxContainer

func _ready() -> void:
	data = _load_json(DATA_PATH)
	character_data = _load_json(CHARACTER_DATA_PATH)
	_reset_state()
	_build_shell()
	_show_main_menu()

func _process(delta: float) -> void:
	scene_time += delta
	for i in lamp_glows.size():
		var glow := lamp_glows[i]
		var color := glow.color
		color.a = 0.11 + sin(scene_time * 1.4 + float(i)) * 0.025
		glow.color = color
	for i in steam_lines.size():
		var steam := steam_lines[i]
		steam.position.y -= 8.0 * delta
		var color := steam.color
		color.a -= 0.16 * delta
		if color.a <= 0.05:
			color.a = 0.28
			steam.position.y += 24.0
		steam.color = color
	_update_customer_walk(delta)
	if not ambience_enabled:
		return
	for line in rain_lines:
		line.position.y += 118.0 * delta
		if line.position.y > SCENE_HEIGHT + 20.0:
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
	bg.color = Color("#1b1009")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var glow := ColorRect.new()
	glow.color = Color(0.85, 0.48, 0.18, 0.12)
	glow.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(glow)

	root_layer = MarginContainer.new()
	root_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	root_layer.add_theme_constant_override("margin_left", 18)
	root_layer.add_theme_constant_override("margin_right", 18)
	root_layer.add_theme_constant_override("margin_top", 14)
	root_layer.add_theme_constant_override("margin_bottom", 14)
	add_child(root_layer)

	var main := VBoxContainer.new()
	main.add_theme_constant_override("separation", 10)
	root_layer.add_child(main)

	var cafe_frame := PanelContainer.new()
	cafe_frame.custom_minimum_size = Vector2(0, SCENE_HEIGHT)
	cafe_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cafe_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cafe_frame.size_flags_stretch_ratio = 1.65
	cafe_frame.add_theme_stylebox_override("panel", _panel_style(Color("#21150d"), Color("#6b4728"), 10))
	main.add_child(cafe_frame)

	scene_layer = Control.new()
	scene_layer.clip_contents = true
	scene_layer.custom_minimum_size = Vector2(SCENE_WIDTH, SCENE_HEIGHT)
	cafe_frame.add_child(scene_layer)

	var bottom_panel := PanelContainer.new()
	bottom_panel.custom_minimum_size = Vector2(0, 252)
	bottom_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_stretch_ratio = 1.0
	bottom_panel.add_theme_stylebox_override("panel", _panel_style(Color("#24150d"), Color("#6b4728"), 12))
	main.add_child(bottom_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	bottom_panel.add_child(margin)

	var bottom := VBoxContainer.new()
	bottom.add_theme_constant_override("separation", 10)
	margin.add_child(bottom)

	top_bar = HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 8)
	bottom.add_child(top_bar)

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom.add_child(scroll)

	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(content)
	_render_cafe_scene()

func _build_rain() -> void:
	if scene_layer == null:
		return
	for i in 42:
		var line := ColorRect.new()
		line.color = Color(0.58, 0.72, 0.86, 0.20)
		line.size = Vector2(2, 14 + (i % 4) * 5)
		line.position = Vector2((i * 83) % int(SCENE_WIDTH), (i * 37) % int(SCENE_HEIGHT))
		line.rotation = deg_to_rad(-8)
		scene_layer.add_child(line)
		rain_lines.append(line)

func _panel_style(fill: Color, border: Color, radius := 18) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
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
	_render_cafe_scene("menu")
	_add_heading("Quán đã lên đèn.")
	_add_paragraph(data.get("game", {}).get("vision", ""))
	_add_paragraph("Bản demo tập trung vào 5 đêm đầu: mở quán, lắng nghe, chọn món đúng lúc, và ghi lại những gì khách để lại.")
	var continue_button := _button("Tiếp tục", _load_game)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	content.add_child(continue_button)
	content.add_child(_button("Chơi mới", _new_game))
	content.add_child(_button("Cài đặt", _show_settings))
	content.add_child(_button("Credits / License notes", _show_credits))
	content.add_child(_button("Thoát", func(): get_tree().quit()))

func _new_game() -> void:
	_reset_state()
	_save_game()
	_show_prep()

func _show_settings() -> void:
	_clear()
	_setup_top_bar(false)
	_render_cafe_scene("settings")
	_add_heading("Cài đặt")
	_add_paragraph("Các thanh âm lượng là hướng UI cho bản demo public. Hiện tại bản này đã có ambience mưa thị giác, audio thật sẽ được gắn ở phase sau.")
	_add_slider_row("Âm lượng nhạc", 58)
	_add_slider_row("Âm lượng ambience", 72)
	_add_slider_row("Tốc độ thoại", 62)
	var ambience_button := _button("Bật/tắt hiệu ứng mưa: %s" % ("BẬT" if ambience_enabled else "TẮT"), func():
		ambience_enabled = not ambience_enabled
		for line in rain_lines:
			line.visible = ambience_enabled
		_show_settings()
	)
	content.add_child(ambience_button)
	content.add_child(_button("Fullscreen / Windowed", func(): DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED)))
	content.add_child(_button("Quay lại", _show_main_menu))

func _show_credits() -> void:
	_clear()
	_setup_top_bar(false)
	_render_cafe_scene("credits")
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
	_render_cafe_scene("prep")
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
	_render_cafe_scene("dialogue", str(current_visit["customer_id"]))
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
	_add_filter_chips(["Đồ uống", "Món nóng", "Món no bụng", "Món dịu", "Món tỉnh táo"])
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for recipe in _available_recipes():
		var recipe_id: String = str(recipe["id"])
		var b := _button(_recipe_button_text(recipe), func(): _show_cooking_panel(recipe_id))
		b.tooltip_text = "%s\nTags: %s / %s" % [recipe["description"], ", ".join(recipe.get("flavor_tags", [])), ", ".join(recipe.get("emotion_tags", []))]
		grid.add_child(b)
	content.add_child(grid)

func _show_cooking_panel(recipe_id: String) -> void:
	var recipe := _recipe(recipe_id)
	_clear()
	_setup_top_bar(true)
	_render_cafe_scene("cook", str(current_visit.get("customer_id", "")), recipe_id)
	_add_heading("Chuẩn bị món")
	_add_meta("Món đang làm: %s" % recipe.get("name", "Món nóng"))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(row)
	row.add_child(_asset_texture_rect(_recipe_sprite_path(recipe), Vector2(80, 80)))
	var preview := VBoxContainer.new()
	preview.add_theme_constant_override("separation", 6)
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(preview)
	preview.add_child(_stage_label(str(recipe.get("description", "")), Color("#f1d8a0"), 16))
	preview.add_child(_stage_label("Chọn cảm giác món muốn gửi vào đêm nay.", Color("#9d8464"), 13))
	_add_subheading("Hương vị / cảm xúc")
	_add_filter_chips(recipe.get("flavor_tags", []) + recipe.get("emotion_tags", []), true)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(actions)
	actions.add_child(_button("Mời khách", func(): _serve_recipe(recipe_id)))
	actions.add_child(_button("Làm lại", _return_to_recipe_selection))
	actions.add_child(_button("Ghi chú", _show_notebook))

func _return_to_recipe_selection() -> void:
	_clear()
	_setup_top_bar(true)
	_render_cafe_scene("dialogue", str(current_visit.get("customer_id", "")))
	_show_recipe_selection()

func _serve_recipe(recipe_id: String) -> void:
	var result := _reaction_result(recipe_id)
	var recipe := _recipe(recipe_id)
	_clear()
	_setup_top_bar(true)
	var customer := _customer(current_visit["customer_id"])
	_render_cafe_scene("serve", str(current_visit["customer_id"]), recipe_id, result)
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
	_render_cafe_scene("closing")
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
	_render_cafe_scene("notebook")
	_add_heading("Sổ ghi chép của quán")
	_add_paragraph("Không phải hồ sơ khách hàng. Chỉ là những điều quán học cách nhớ.")
	_add_notebook_tabs("Khách quen")
	for customer_id in data["customers"].keys():
		var customer: Dictionary = data["customers"][customer_id]
		var notes: Array = state["customer_notes"].get(customer_id, [])
		if notes.is_empty():
			_add_paper_note(str(customer["name"]), str(customer["short_description"]), ["Chưa có ghi chú."])
		else:
			_add_paper_note(str(customer["name"]), str(customer["short_description"]), notes)
	_add_subheading("Vật kỷ niệm")
	if state["keepsakes"].is_empty():
		_add_paper_note("Kệ nhỏ bên quầy", "Vật khách để lại", ["Chưa có gì ngoài vài vệt nước mưa trước cửa."])
	else:
		_add_paper_note("Kệ nhỏ bên quầy", "Vật khách để lại", state["keepsakes"])
	content.add_child(_button("Quay lại đêm hiện tại", _return_to_current_flow))

func _show_recipe_book() -> void:
	_clear()
	_setup_top_bar(false)
	_render_cafe_scene("recipes")
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
	_render_cafe_scene("ending")
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

func _render_cafe_scene(mode := "idle", customer_id := "", recipe_id := "", result := "") -> void:
	if scene_layer == null:
		return
	for child in scene_layer.get_children():
		child.queue_free()
	rain_lines.clear()
	steam_lines.clear()
	lamp_glows.clear()
	walking_customer = null
	walking_customer_state = "idle"
	walking_path.clear()
	walking_target_index = 0

	_add_scene_rect(Vector2.ZERO, Vector2(SCENE_WIDTH, SCENE_HEIGHT), Color("#18202a"))
	_add_scene_rect(Vector2(0, 0), Vector2(SCENE_WIDTH, 88), Color("#24150d"))
	_add_scene_rect(Vector2(0, 88), Vector2(SCENE_WIDTH, SCENE_HEIGHT - 88), Color("#5a351c"))
	_add_floor_tiles()

	_add_window(Vector2(56, 24), Vector2(250, 72))
	_add_window(Vector2(930, 24), Vector2(260, 72))
	_add_warm_light(Vector2(220, 112), Vector2(250, 170), 0.16)
	_add_warm_light(Vector2(560, 102), Vector2(340, 185), 0.20)
	_add_warm_light(Vector2(880, 122), Vector2(250, 160), 0.13)

	_add_menu_board()
	_add_clock(Vector2(818, 34))
	_add_scene_label("22:00 - 04:00", Vector2(984, 104), Vector2(190, 24), Color("#9d8464"), 13)

	_add_counter_and_props()
	_add_tables_and_seats()
	_add_character_sprite("player", Vector2(640, 236), "idle_down", Color("#fff3dc"))

	var active_customer := customer_id
	if active_customer != "ban_hoa":
		_add_customer_in_scene("ban_hoa", Vector2(178, 246), false)
	if active_customer != "bao_ve":
		_add_customer_in_scene("bao_ve", Vector2(1026, 246), false)
	if active_customer != "sinh_vien":
		_add_customer_in_scene("sinh_vien", Vector2(384, 300), false)
	if active_customer != "":
		_add_customer_walk_in_scene(active_customer, Vector2(610, 238))
	elif mode in ["menu", "prep", "closing", "notebook", "recipes", "ending"]:
		_add_customer_in_scene("tai_xe", Vector2(610, 238), false)

	_add_counter_front_overlay()
	_add_table_front_overlays()
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cat.png", Vector2(110, 390), -1, Vector2i(16, 16), 3.0, 4.0, Color("#ffe8c2"))
	_add_steam(Vector2(548, 180))
	_add_steam(Vector2(705, 182))
	_add_scene_status(mode, customer_id, recipe_id, result)
	_build_rain()

func _add_floor_tiles() -> void:
	for x in range(0, int(SCENE_WIDTH), 32):
		var line := ColorRect.new()
		line.color = Color(0.12, 0.07, 0.04, 0.20)
		line.position = Vector2(x, 88)
		line.size = Vector2(1, SCENE_HEIGHT - 88)
		scene_layer.add_child(line)
	for y in range(88, int(SCENE_HEIGHT), 32):
		var line := ColorRect.new()
		line.color = Color(0.12, 0.07, 0.04, 0.18)
		line.position = Vector2(0, y)
		line.size = Vector2(SCENE_WIDTH, 1)
		scene_layer.add_child(line)

func _add_window(pos: Vector2, rect_size: Vector2) -> void:
	_add_scene_rect(pos, rect_size, Color("#0d151f"))
	_add_scene_rect(pos + Vector2(5, 5), rect_size - Vector2(10, 10), Color("#18202a"))
	_add_scene_rect(pos + Vector2(rect_size.x * 0.5 - 1, 5), Vector2(2, rect_size.y - 10), Color("#34414a"))
	_add_scene_rect(pos + Vector2(5, rect_size.y * 0.5 - 1), Vector2(rect_size.x - 10, 2), Color("#34414a"))
	for i in 9:
		var streak := ColorRect.new()
		streak.color = Color(0.58, 0.72, 0.86, 0.22)
		streak.position = pos + Vector2(22 + i * 24, 8 + (i % 3) * 9)
		streak.size = Vector2(2, 30)
		streak.rotation = deg_to_rad(-8)
		scene_layer.add_child(streak)

func _add_warm_light(pos: Vector2, rect_size: Vector2, alpha: float) -> void:
	var light := ColorRect.new()
	light.color = Color(1.0, 0.64, 0.24, alpha)
	light.position = pos
	light.size = rect_size
	scene_layer.add_child(light)
	lamp_glows.append(light)

func _add_menu_board() -> void:
	var board := PanelContainer.new()
	board.position = Vector2(382, 22)
	board.size = Vector2(270, 74)
	board.add_theme_stylebox_override("panel", _panel_style(Color("#11110d"), Color("#6b4728"), 3))
	scene_layer.add_child(board)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 10)
	margin.add_theme_constant_override("margin_right", 10)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_bottom", 7)
	board.add_child(margin)

	var lines := VBoxContainer.new()
	lines.add_theme_constant_override("separation", 2)
	margin.add_child(lines)
	lines.add_child(_stage_label("MENU ĐÊM", Color("#d7a64b"), 15))
	lines.add_child(_stage_label("cà phê phin  ·  trà gừng", Color("#f1d8a0"), 11))
	lines.add_child(_stage_label("cháo nóng  ·  mì trứng", Color("#f1d8a0"), 11))

func _add_clock(pos: Vector2) -> void:
	_add_scene_rect(pos, Vector2(42, 42), Color("#2b1b12"))
	_add_scene_rect(pos + Vector2(5, 5), Vector2(32, 32), Color("#d7a64b"))
	_add_scene_rect(pos + Vector2(10, 10), Vector2(22, 22), Color("#24150d"))
	_add_scene_rect(pos + Vector2(20, 14), Vector2(2, 10), Color("#f1d8a0"))
	_add_scene_rect(pos + Vector2(21, 22), Vector2(9, 2), Color("#f1d8a0"))

func _add_counter_and_props() -> void:
	_add_scene_rect(Vector2(304, 150), Vector2(672, 32), Color("#7a4d31"), 20)
	_add_scene_rect(Vector2(284, 182), Vector2(712, 74), Color("#3a2418"), 20)
	_add_scene_rect(Vector2(304, 194), Vector2(672, 10), Color("#8f6a45"), 20)
	_add_scene_rect(Vector2(508, 112), Vector2(250, 34), Color("#332016"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png", Vector2(552, 198), -1, Vector2i(16, 16), 3.0, 4.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_pan_with_omelette.png", Vector2(712, 198), 12, Vector2i(16, 16), 3.0, 5.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_sink_1.png", Vector2(792, 198), -1, Vector2i(16, 16), 3.0, 3.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(436, 198), -1, Vector2i(16, 16), 3.0, 5.0, Color("#ffdca2"))
	_add_scene_rect(Vector2(894, 142), Vector2(38, 52), Color("#24412b"))
	_add_scene_rect(Vector2(906, 118), Vector2(14, 26), Color("#4c7a47"))
	_add_scene_rect(Vector2(930, 130), Vector2(14, 18), Color("#5c8a52"))
	_add_scene_label("quầy pha", Vector2(584, 210), Vector2(120, 22), Color("#9d8464"), 13)

func _add_counter_front_overlay() -> void:
	_add_scene_rect(Vector2(284, 206), Vector2(712, 50), Color("#2b1b12"), 260)
	_add_scene_rect(Vector2(304, 206), Vector2(672, 8), Color("#8f6a45"), 261)
	_add_scene_rect(Vector2(304, 250), Vector2(672, 6), Color("#1b1009"), 261)

func _add_tables_and_seats() -> void:
	_add_scene_rect(Vector2(142, 244), Vector2(108, 66), Color("#3a2418"))
	_add_scene_rect(Vector2(158, 260), Vector2(76, 34), Color("#7a4d31"))
	_add_scene_rect(Vector2(1006, 244), Vector2(112, 66), Color("#3a2418"))
	_add_scene_rect(Vector2(1024, 260), Vector2(76, 34), Color("#7a4d31"))
	_add_scene_rect(Vector2(354, 298), Vector2(118, 64), Color("#3a2418"))
	_add_scene_rect(Vector2(374, 314), Vector2(78, 32), Color("#7a4d31"))
	for pos in [Vector2(590, 262), Vector2(652, 262), Vector2(714, 262)]:
		_add_scene_rect(pos, Vector2(34, 28), Color("#2a1a12"))

func _add_table_front_overlays() -> void:
	_add_scene_rect(Vector2(158, 278), Vector2(76, 16), Color("#6b4728"), 340)
	_add_scene_rect(Vector2(1024, 278), Vector2(76, 16), Color("#6b4728"), 340)
	_add_scene_rect(Vector2(374, 330), Vector2(78, 16), Color("#6b4728"), 380)
	for pos in [Vector2(590, 274), Vector2(652, 274), Vector2(714, 274)]:
		_add_scene_rect(pos, Vector2(34, 16), Color("#1b1009"), 340)

func _add_customer_in_scene(customer_id: String, pos: Vector2, active := false) -> void:
	if active:
		_add_warm_light(pos - Vector2(18, 18), Vector2(104, 104), 0.16)
		_add_scene_label("...", pos + Vector2(26, -18), Vector2(48, 20), Color("#f1d8a0"), 15)
	var customer := _add_character_sprite(customer_id, pos + Vector2(32, 64), "idle_down", Color("#ffffff") if active else Color("#d5c2a6"))
	customer.sit_down()

func _add_customer_walk_in_scene(customer_id: String, seat_pos: Vector2) -> void:
	_add_warm_light(seat_pos - Vector2(18, 18), Vector2(104, 104), 0.16)
	_add_scene_label("...", seat_pos + Vector2(26, -18), Vector2(48, 20), Color("#f1d8a0"), 15)
	var spawn := Vector2(1190, 198)
	var approach := Vector2(876, 246)
	var seat_foot := seat_pos + Vector2(32, 64)
	walking_customer = _add_character_sprite(customer_id, spawn, "walk_left", Color("#ffffff"))
	walking_customer.set_animation_state("walk", "left")
	walking_customer_state = "walking_to_seat"
	walking_path = [approach, seat_foot]
	walking_target_index = 0

func _update_customer_walk(delta: float) -> void:
	if walking_customer == null or walking_path.is_empty() or walking_customer_state == "seated_idle":
		return
	if walking_target_index >= walking_path.size():
		_seat_walking_customer()
		return
	var target: Vector2 = walking_path[walking_target_index]
	var to_target: Vector2 = target - walking_customer.position
	if to_target.length() <= 2.0:
		walking_customer.position = target.floor()
		walking_target_index += 1
		if walking_target_index >= walking_path.size():
			_seat_walking_customer()
		return
	var direction := "right" if to_target.x > 0.0 else "left"
	walking_customer.set_animation_state("walk", direction)
	walking_customer.position += to_target.normalized() * 82.0 * delta
	walking_customer.position = walking_customer.position.floor()
	walking_customer.z_index = int(walking_customer.position.y)

func _seat_walking_customer() -> void:
	if walking_customer == null:
		return
	walking_customer_state = "seated_idle"
	walking_customer.velocity = Vector2.ZERO
	walking_customer.flip_h = false
	walking_customer.sit_down()
	walking_customer.z_index = int(walking_customer.position.y)

func _add_steam(origin: Vector2) -> void:
	for i in 3:
		var steam := ColorRect.new()
		steam.color = Color(0.86, 0.9, 0.86, 0.28 - i * 0.05)
		steam.position = origin + Vector2(i * 9, -i * 8)
		steam.size = Vector2(4, 20)
		steam.rotation = deg_to_rad(-8 + i * 7)
		scene_layer.add_child(steam)
		steam_lines.append(steam)

func _add_scene_status(mode: String, customer_id: String, recipe_id: String, result: String) -> void:
	var pill := PanelContainer.new()
	pill.position = Vector2(32, 112)
	pill.size = Vector2(300, 74)
	pill.add_theme_stylebox_override("panel", _panel_style(Color(0.08, 0.05, 0.03, 0.82), Color("#6b4728"), 6))
	scene_layer.add_child(pill)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	pill.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 2)
	margin.add_child(box)
	box.add_child(_stage_label(_scene_title_for_mode(mode), Color("#d7a64b"), 15))
	if customer_id != "":
		box.add_child(_stage_label("Khách: %s" % _customer(customer_id).get("name", "khách lạ"), Color("#f1d8a0"), 13))
	elif recipe_id != "":
		box.add_child(_stage_label("Món: %s" % _recipe(recipe_id).get("name", "món nóng"), Color("#f1d8a0"), 13))
	else:
		var night_number := int(state.get("current_night", 1))
		box.add_child(_stage_label("Đêm %s · mưa nhẹ ngoài hẻm" % night_number, Color("#f1d8a0"), 13))
	if result != "":
		box.add_child(_stage_label("Phản ứng: %s" % _reaction_label(result), Color("#b8d7c5"), 12))

	if mode == "menu":
		_add_scene_label(str(data.get("game", {}).get("title", "Đèn Hẻm Sau Mưa")), Vector2(418, 304), Vector2(470, 44), Color("#ffd58a"), 32, HORIZONTAL_ALIGNMENT_CENTER)
		_add_scene_label("Một quán nhỏ mở khi thành phố đã ngủ", Vector2(420, 346), Vector2(470, 28), Color("#f1d8a0"), 15, HORIZONTAL_ALIGNMENT_CENTER)

func _scene_title_for_mode(mode: String) -> String:
	match mode:
		"menu":
			return "Quán vừa lên đèn"
		"prep":
			return "Chuẩn bị trước giờ mở cửa"
		"dialogue":
			return "Khách đang kể chuyện"
		"serve":
			return "Món vừa được dọn ra"
		"cook":
			return "Đang pha/nấu sau quầy"
		"closing":
			return "Sau khi đóng quán"
		"notebook":
			return "Sổ quán đang mở"
		"recipes":
			return "Sổ công thức"
		"settings":
			return "Cài đặt nhịp đêm"
		"ending":
			return "Trời gần sáng"
		_:
			return "Góc quán lúc nửa đêm"

func _add_scene_rect(pos: Vector2, rect_size: Vector2, color: Color, z := 0) -> ColorRect:
	var rect := ColorRect.new()
	rect.color = color
	rect.position = pos
	rect.size = rect_size
	rect.z_index = z
	scene_layer.add_child(rect)
	return rect

func _add_scene_sprite(path: String, pos: Vector2, sprite_size: Vector2, tint := Color.WHITE) -> TextureRect:
	var sprite := TextureRect.new()
	sprite.texture = _atlas_texture(path, Rect2(0, 0, AssetCatalog.TILE_SIZE, AssetCatalog.TILE_SIZE))
	sprite.position = pos
	sprite.size = sprite_size
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.modulate = tint
	scene_layer.add_child(sprite)
	return sprite

func _add_animated_prop(path: String, foot_position: Vector2, frame_count := -1, frame_size := Vector2i(16, 16), pixel_scale := 3.0, speed := 4.0, tint := Color.WHITE) -> AnimatedSprite2D:
	var texture := AssetCatalog.load_texture(path)
	var prop := AnimatedSprite2D.new()
	var frames := SpriteFrames.new()
	frames.add_animation("loop")
	frames.set_animation_loop("loop", true)
	frames.set_animation_speed("loop", speed)
	var columns: int = max(1, int(texture.get_width() / frame_size.x))
	var rows: int = max(1, int(texture.get_height() / frame_size.y))
	var total_frames: int = columns * rows
	var frames_to_add: int = total_frames if frame_count < 0 else min(frame_count, total_frames)
	for frame_index in range(frames_to_add):
		var column := frame_index % columns
		var row := int(frame_index / columns)
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(column * frame_size.x, row * frame_size.y, frame_size.x, frame_size.y)
		frames.add_frame("loop", atlas)
	prop.sprite_frames = frames
	prop.animation = "loop"
	prop.centered = true
	prop.offset = Vector2(0, -float(frame_size.y) * 0.5)
	prop.position = foot_position.floor()
	prop.scale = Vector2(pixel_scale, pixel_scale)
	prop.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	prop.modulate = tint
	prop.z_index = int(foot_position.y)
	scene_layer.add_child(prop)
	prop.play()
	return prop

func _add_character_sprite(character_id: String, foot_position: Vector2, animation_name := "", tint := Color.WHITE) -> CharacterSpriteController:
	var controller := CharacterSpriteController.new()
	controller.position = foot_position.floor()
	controller.z_index = int(foot_position.y)
	controller.modulate = tint
	scene_layer.add_child(controller)
	controller.configure(character_id, _character_config(character_id), animation_name)
	return controller

func _character_config(character_id: String) -> Dictionary:
	if character_data.has(character_id):
		return character_data[character_id]
	if character_data.has("player"):
		return character_data["player"]
	return {}

func _add_scene_label(text: String, pos: Vector2, label_size: Vector2, color: Color, font_size := 14, align := HORIZONTAL_ALIGNMENT_LEFT) -> Label:
	var label := Label.new()
	label.text = text
	label.position = pos
	label.size = label_size
	label.horizontal_alignment = align
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scene_layer.add_child(label)
	return label

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
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cat.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cuckoo_clock.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_pan_with_omelette.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_sink_1.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_toaster.png", Vector2(48, 48)))
	props.add_child(_asset_texture_rect(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(48, 48)))

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
		recipe_row.add_child(_asset_texture_rect(_recipe_sprite_path(recipe), Vector2(48, 48)))

		var recipe_text := VBoxContainer.new()
		recipe_text.add_theme_constant_override("separation", 3)
		recipe_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		recipe_row.add_child(recipe_text)
		recipe_text.add_child(_stage_label(str(recipe.get("name", "Món vừa dọn")), Color("#ffd58a"), 16))
		recipe_text.add_child(_stage_label("Phản ứng: %s" % _reaction_label(result), Color("#b8d7c5"), 13))
	elif not state.get("keepsakes", []).is_empty():
		var keepsakes: Array = state.get("keepsakes", [])
		details.add_child(_stage_label("Vật kỷ niệm mới nhất: %s" % str(keepsakes.back()), Color("#d6b98a"), 13))

func _asset_texture_rect(path: String, target_size: Vector2, region := Rect2(0, 0, 16, 16), use_region := true) -> TextureRect:
	var rect := TextureRect.new()
	rect.custom_minimum_size = target_size
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Adam_idle_16x16.png"
		"van_phong":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Amelia_idle_16x16.png"
		"bao_ve":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Old_man_Josh_idle_16x16.png"
		"sinh_vien":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Samuel_idle_16x16.png"
		"ban_hoa":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Old_woman_Jenny_idle_16x16.png"
		"cap_doi":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Lucy_idle_16x16.png"
		"y_ta":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Cleaner_girl_idle_16x16.png"
		"dev":
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Rob_idle_16x16.png"
		_:
			return AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Chef_Alex_idle_16x16.png"

func _recipe_sprite_path(recipe: Dictionary) -> String:
	var name := str(recipe.get("name", "")).to_lower()
	var base := str(recipe.get("base", "")).to_lower()
	if base.contains("cà phê") or name.contains("cà phê") or name.contains("bạc xỉu"):
		return AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png"
	if name.contains("trà") or name.contains("sữa") or name.contains("cacao"):
		return AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png"
	if name.contains("bánh mì"):
		return AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_toaster.png"
	return AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_pan_with_omelette.png"

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

func _add_filter_chips(labels: Array, active := false) -> void:
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 8)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(flow)
	for label in labels:
		flow.add_child(_chip(str(label).capitalize(), active))

func _chip(text: String, active := false) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.add_theme_stylebox_override("panel", _panel_style(Color("#4a2d18") if active else Color("#2a1a12"), Color("#d7a64b") if active else Color("#6b4728"), 4))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	chip.add_child(margin)
	margin.add_child(_stage_label(text, Color("#ffe3ad") if active else Color("#9d8464"), 13))
	return chip

func _add_slider_row(label_text: String, value: float) -> void:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(row)
	var label := _stage_label(label_text, Color("#f1d8a0"), 15)
	label.custom_minimum_size = Vector2(180, 30)
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.value = value
	slider.step = 1
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(slider)

func _add_notebook_tabs(active_tab: String) -> void:
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.add_child(tabs)
	for tab in ["Khách quen", "Công thức", "Món ký ức", "Vật kỷ niệm", "Đêm đã qua"]:
		tabs.add_child(_chip(tab, tab == active_tab))

func _add_paper_note(title: String, subtitle: String, lines: Array) -> void:
	var paper := PanelContainer.new()
	paper.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	paper.add_theme_stylebox_override("panel", _panel_style(Color("#ead7ad"), Color("#8f6a45"), 5))
	content.add_child(paper)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	paper.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 5)
	margin.add_child(box)
	box.add_child(_stage_label(title, Color("#3a2418"), 17))
	box.add_child(_stage_label(subtitle, Color("#6b4728"), 12))
	for line in lines:
		box.add_child(_stage_label("• %s" % str(line), Color("#2b1b12"), 14))

func _button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 42)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_color_override("font_color", Color("#ffe8c2"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#3a2b24")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#5a3d2d")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#7a4d31")))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#201711")))
	button.add_theme_color_override("font_disabled_color", Color("#6f5a40"))
	button.pressed.connect(callable)
	return button

func _button_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color("#8f6a45")
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
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
