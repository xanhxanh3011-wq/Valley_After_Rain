extends Control

const DATA_PATH := "res://data/demo_content.json"
const PRODUCTION_PATCH_PATH := "res://data/production_content_patch.json"
const CHARACTER_DATA_PATH := "res://data/characters.json"
const SPRITE_SLICE_PRESET_PATH := "res://data/sprite_slice_presets.json"
const SETTINGS_PATH := "user://night_cafe_settings.json"
const SAVE_PATH := "user://night_cafe_demo_save.json"
const SAVE_VERSION := 2
const UI_ICON_COFFEE_PATH := "res://assets/generated/ui/icons_16x16/coffee.png"
const UI_ICON_TEA_PATH := "res://assets/generated/ui/icons_16x16/tea.png"
const UI_ICON_BOWL_PATH := "res://assets/generated/ui/icons_16x16/bowl.png"
const UI_ICON_CAKE_PATH := "res://assets/generated/ui/icons_16x16/cake.png"
const UI_ICON_BREAD_PATH := "res://assets/generated/ui/icons_16x16/bread.png"
const UI_ICON_PLATE_PATH := "res://assets/generated/ui/icons_16x16/omelette_rice.png"
const UI_ICON_MILK_PATH := "res://assets/generated/ui/icons_16x16/tea.png"
const UI_ICON_EGG_PATH := "res://assets/generated/ui/icons_16x16/omelette_rice.png"
const UI_ICON_NOODLES_PATH := "res://assets/generated/ui/icons_16x16/bowl.png"
const UI_ICON_RICE_PATH := "res://assets/generated/ui/icons_16x16/omelette_rice.png"
const UI_ICON_TEAPOT_PATH := "res://assets/generated/ui/icons_16x16/tea.png"
const UI_ICON_TOAST_PATH := "res://assets/generated/ui/icons_16x16/bread.png"
const UI_ICON_HOT_COCOA_PATH := "res://assets/generated/ui/icons_16x16/coffee.png"
const UI_ICON_HONEY_LEMON_TEA_PATH := "res://assets/generated/ui/icons_16x16/tea.png"
const UI_ICON_HERBAL_TEA_PATH := "res://assets/generated/ui/icons_16x16/tea.png"
const UI_ICON_PORRIDGE_PATH := "res://assets/generated/ui/icons_16x16/bowl.png"
const UI_ICON_FRIED_RICE_PATH := "res://assets/generated/ui/icons_16x16/omelette_rice.png"
const UI_ICON_SANDWICH_PATH := "res://assets/generated/ui/icons_16x16/bread.png"
const UI_ICON_OMELETTE_RICE_PATH := "res://assets/generated/ui/icons_16x16/omelette_rice.png"
const BGM_TRACK_PATHS := [
	"res://assets/generated/audio/lonely_in_the_bar_mixkit.mp3",
	"res://assets/generated/audio/romantic_01_mixkit.mp3",
	"res://assets/generated/audio/thinking_about_you_mixkit.mp3",
	"res://assets/generated/audio/slow_walk_mixkit.mp3",
	"res://assets/generated/audio/jazz_1_mixkit.mp3",
	"res://assets/generated/audio/dreamy_jazz_mixkit.mp3",
	"res://assets/generated/audio/bgm_extra_01.mp3",
	"res://assets/generated/audio/bgm_extra_02.mp3",
	"res://assets/generated/audio/bgm_extra_03.mp3",
	"res://assets/generated/audio/bgm_extra_04.mp3",
	"res://assets/generated/audio/bgm_extra_05.mp3",
	"res://assets/generated/audio/bgm_extra_06.mp3",
	"res://assets/generated/audio/bgm_extra_07.mp3",
	"res://assets/generated/audio/bgm_extra_08.mp3"
]
const RAIN_AMBIENCE_PATHS := [
	"res://assets/generated/audio/ambience/rain_light_loop.mp3",
	"res://assets/generated/audio/ambience/rain_atmosphere.mp3"
]
const CRICKET_AMBIENCE_PATHS := [
	"res://assets/generated/audio/ambience/crickets_night.mp3"
]
const TRAFFIC_AMBIENCE_PATHS := [
	"res://assets/generated/audio/ambience/traffic_city.mp3",
	"res://assets/generated/audio/ambience/city_night.mp3"
]
const DOG_AMBIENCE_PATHS := [
	"res://assets/generated/audio/ambience/dog_bark_twice.mp3"
]
const SCENE_BACKDROP_PATH := "res://assets/generated/backgrounds/night_cafe_topdown_full.png"
const SCENE_BACKDROP_HD_PATH := "res://assets/generated/backgrounds/night_cafe_topdown_hd.png"
const AssetCatalog := preload("res://scripts/core/asset_catalog.gd")
const CharacterSpriteController := preload("res://scripts/visual/character_sprite_controller.gd")
const SCENE_WIDTH := 1280.0
const SCENE_HEIGHT := 430.0
const CHARACTER_SCENE_OFFSET := Vector2(23, -12)

var data: Dictionary
var character_data: Dictionary
var sprite_slice_presets: Dictionary
var cached_16x16_asset_paths: Array[String] = []
var state: Dictionary
var current_night_index := 0
var current_visit_index := 0
var current_visit: Dictionary = {}
var current_choice: Dictionary = {}
var selected_menu: Array[String] = []
var menu_recipe_buttons: Dictionary = {}
var menu_selection_label: Label
var recipe_selection_detail_root: VBoxContainer
var recipe_selection_summary_label: Label
var recipe_selection_title_label: Label
var recipe_selection_desc_label: Label
var recipe_selection_menu_list: Array = []
var settings_asset_picker_overlay: Control
var settings_asset_picker_list: ItemList
var settings_asset_picker_filter: LineEdit
var settings_asset_picker_button: Button
var settings_asset_picker_usage: Label
var selected_slice_texture := ""
var recipe_book_selected_id := ""
var notebook_active_tab := "Khách quen"
var ui_settings: Dictionary = {}
var ui_scale := 1.0
var ambience_enabled := true
var rain_lines: Array[ColorRect] = []
var steam_lines: Array[ColorRect] = []
var lamp_glows: Array[Control] = []
var scene_time := 0.0
var walking_customer: CharacterSpriteController
var walking_customer_state := "idle"
var walking_path: Array[Vector2] = []
var walking_target_index := 0
var walking_seat_foot := Vector2.ZERO
var screen_history: Array[String] = []
var current_scene_mode := "idle"
var current_scene_customer_id := ""
var current_scene_recipe_id := ""
var current_scene_result := ""
var current_scene_animate_entry := false
var current_scene_walk_in_customer_id := ""
var customer_transition_in_progress := false
var decorate_mode := false
var decorate_tool := ""
var decorate_selected_background := ""
var decorate_selected_chef := ""
var decorate_selected_prop := ""
var decorate_return_scene: Dictionary = {}

var root_layer: Control
var cafe_frame: PanelContainer
var bottom_panel: PanelContainer
var overlay_layer: CanvasLayer
var overlay_root: Control
var weather_fx_root: Control
var scene_overlay_root: Control
var scene_hud_root: Control
var scene_layer: Control
var content: VBoxContainer
var ui_text_parent: Control
var bottom_scroll_body: VBoxContainer
var title_label: Label
var subtitle_label: Label
var top_bar: HBoxContainer
var ambience_player: AudioStreamPlayer
var rain_audio_player: AudioStreamPlayer
var cricket_audio_player: AudioStreamPlayer
var traffic_audio_player: AudioStreamPlayer
var dog_audio_player: AudioStreamPlayer
var dog_bark_timer: Timer
var radio_audio_player: AudioStreamPlayer
var bgm_player: AudioStreamPlayer
var ui_click_player: AudioStreamPlayer
var cup_sfx_player: AudioStreamPlayer
var audio_rng := RandomNumberGenerator.new()

func _ready() -> void:
	audio_rng.randomize()
	data = _load_json(DATA_PATH)
	_merge_content_patch(PRODUCTION_PATCH_PATH)
	character_data = _load_json(CHARACTER_DATA_PATH)
	sprite_slice_presets = _load_json(SPRITE_SLICE_PRESET_PATH)
	ui_settings = _load_json(SETTINGS_PATH)
	_reset_state()
	_build_shell()
	_setup_audio()
	var viewport := get_viewport()
	if viewport != null and not viewport.size_changed.is_connected(_sync_viewport_dependent_layout):
		viewport.size_changed.connect(_sync_viewport_dependent_layout)
	_apply_saved_ui_settings()
	_start_ambience()
	_collect_png_asset_paths()
	_show_main_menu()

func _process(delta: float) -> void:
	scene_time += delta
	for i in range(lamp_glows.size() - 1, -1, -1):
		var glow := lamp_glows[i]
		if not is_instance_valid(glow):
			lamp_glows.remove_at(i)
			continue
		var tint := glow.modulate
		tint.a = 0.11 + sin(scene_time * 1.4 + float(i)) * 0.025
		glow.modulate = tint
	for i in range(steam_lines.size() - 1, -1, -1):
		var steam := steam_lines[i]
		if not is_instance_valid(steam):
			steam_lines.remove_at(i)
			continue
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
	var bounds := get_viewport_rect().size
	if weather_fx_root != null:
		bounds = weather_fx_root.size
	for i in range(rain_lines.size() - 1, -1, -1):
		var line := rain_lines[i]
		if not is_instance_valid(line):
			rain_lines.remove_at(i)
			continue
		line.position.y += 118.0 * delta
		if line.position.y > bounds.y + 20.0:
			line.position.y = -20.0

func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var text := FileAccess.get_file_as_string(path)
	if text.strip_edges() == "":
		return {}
	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Cannot parse content data: %s" % path)
		return {}
	return parsed

func _merge_content_patch(path: String) -> void:
	if not FileAccess.file_exists(path):
		return
	var patch := _load_json(path)
	if patch.is_empty():
		return
	for key in patch.get("game", {}).keys():
		data["game"][key] = patch["game"][key]
	_merge_recipe_patch(patch.get("recipes", []))
	for customer_id in patch.get("customers", {}).keys():
		data["customers"][customer_id] = patch["customers"][customer_id]
	_merge_night_patch(patch.get("nights", []))
	if patch.has("demo_ending"):
		data["demo_ending"] = patch["demo_ending"]
	data["game"]["demo_nights"] = data.get("nights", []).size()

func _merge_recipe_patch(recipes: Array) -> void:
	var known := {}
	for recipe in data.get("recipes", []):
		known[str(recipe.get("id", ""))] = true
	for recipe in recipes:
		var recipe_id := str(recipe.get("id", ""))
		if recipe_id != "" and not known.has(recipe_id):
			data["recipes"].append(recipe)
			known[recipe_id] = true

func _merge_night_patch(nights: Array) -> void:
	var known := {}
	for night in data.get("nights", []):
		known[int(night.get("night_number", 0))] = true
	for night in nights:
		var night_number := int(night.get("night_number", 0))
		if night_number > 0 and not known.has(night_number):
			data["nights"].append(night)
			known[night_number] = true
	data["nights"].sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("night_number", 0)) < int(b.get("night_number", 0))
	)

func _reset_state() -> void:
	state = {
		"save_version": SAVE_VERSION,
		"current_night": 1,
		"unlocked_recipes": [],
		"customer_notes": {},
		"trust": {},
		"keepsakes": [],
		"completed_visits": [],
		"last_summary": [],
		"seat_positions": {},
		"decor": {
			"background_path": SCENE_BACKDROP_PATH,
			"chef_id": "player",
			"props": []
		},
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

	cafe_frame = PanelContainer.new()
	cafe_frame.custom_minimum_size = Vector2(0, SCENE_HEIGHT)
	cafe_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cafe_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cafe_frame.size_flags_stretch_ratio = 1.9
	cafe_frame.clip_contents = true
	cafe_frame.add_theme_stylebox_override("panel", _panel_style(Color("#21150d"), Color("#6b4728"), 10))
	main.add_child(cafe_frame)

	var scene_holder := CenterContainer.new()
	scene_holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scene_holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	cafe_frame.add_child(scene_holder)

	scene_layer = Control.new()
	scene_layer.clip_contents = true
	scene_layer.custom_minimum_size = Vector2(SCENE_WIDTH, SCENE_HEIGHT)
	scene_layer.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	scene_layer.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	scene_layer.mouse_filter = Control.MOUSE_FILTER_STOP
	scene_holder.add_child(scene_layer)
	scene_layer.gui_input.connect(_on_scene_layer_gui_input)

	scene_overlay_root = Control.new()
	scene_overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	scene_overlay_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene_overlay_root.z_as_relative = false
	scene_overlay_root.z_index = 3000
	scene_layer.add_child(scene_overlay_root)

	bottom_panel = PanelContainer.new()
	bottom_panel.custom_minimum_size = Vector2(0, 230)
	bottom_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_panel.size_flags_stretch_ratio = 0.9
	bottom_panel.clip_contents = true
	bottom_panel.add_theme_stylebox_override("panel", _panel_style(Color("#24150d"), Color("#6b4728"), 12))
	main.add_child(bottom_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	bottom_panel.add_child(margin)

	var bottom_scroll := ScrollContainer.new()
	bottom_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	bottom_scroll.follow_focus = false
	margin.add_child(bottom_scroll)

	var bottom := VBoxContainer.new()
	bottom.add_theme_constant_override("separation", 10)
	bottom.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	bottom_scroll.add_child(bottom)
	bottom_scroll_body = bottom

	top_bar = HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 8)
	top_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_bar.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	bottom.add_child(top_bar)

	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 10)
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	content.clip_contents = true
	bottom.add_child(content)
	ui_text_parent = content
	_build_overlay_layer()
	_sync_viewport_dependent_layout()
	_render_cafe_scene()

func _sync_viewport_dependent_layout() -> void:
	if weather_fx_root != null:
		weather_fx_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	if overlay_root != null:
		overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	if scene_overlay_root != null:
		scene_overlay_root.z_index = 3000
		scene_overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	if scene_hud_root != null:
		scene_hud_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	if root_layer != null:
		root_layer.set_anchors_preset(Control.PRESET_FULL_RECT)

func _apply_saved_ui_settings() -> void:
	if ui_settings.is_empty():
		ui_settings = {
			"resolution": "1280x720"
		}
	_apply_resolution_preset(str(ui_settings.get("resolution", "1280x720")))

func _apply_resolution_preset(preset_name: String) -> void:
	var size := Vector2i(1280, 720)
	ui_settings["resolution"] = "1280x720"
	ui_scale = 1.0
	var window: Window = get_window()
	if window != null:
		window.size = size

func _save_ui_settings() -> void:
	var file := FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write ui settings: %s" % SETTINGS_PATH)
		return
	file.store_string(JSON.stringify(ui_settings, "\t"))
	file.close()

func _build_overlay_layer() -> void:
	overlay_layer = CanvasLayer.new()
	overlay_layer.layer = 32
	add_child(overlay_layer)

	overlay_root = Control.new()
	overlay_root.visible = false
	overlay_root.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(overlay_root)

	scene_hud_root = Control.new()
	scene_hud_root.visible = true
	scene_hud_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene_hud_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_layer.add_child(scene_hud_root)

	weather_fx_root = Control.new()
	weather_fx_root.visible = true
	weather_fx_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	weather_fx_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	if scene_layer != null:
		scene_layer.add_child(weather_fx_root)

func _set_game_layout_mode(mode: String) -> void:
	if cafe_frame == null or bottom_panel == null:
		return
	cafe_frame.custom_minimum_size = Vector2(0, SCENE_HEIGHT)
	cafe_frame.size_flags_stretch_ratio = 1.55
	bottom_panel.custom_minimum_size = Vector2(0, 260)
	bottom_panel.size_flags_stretch_ratio = 0.90
	match mode:
		"book":
			pass
		"dialogue":
			pass
		_:
			pass

func _build_rain() -> void:
	var parent := weather_fx_root if weather_fx_root != null else scene_layer
	if parent == null:
		return
	var bounds := get_viewport_rect().size
	if weather_fx_root != null and weather_fx_root.size != Vector2.ZERO:
		bounds = weather_fx_root.size
	for i in 42:
		var line := ColorRect.new()
		line.color = Color(0.58, 0.72, 0.86, 0.20)
		line.size = Vector2(2, 14 + (i % 4) * 5)
		line.position = Vector2((i * 83) % int(SCENE_WIDTH), (i * 37) % int(SCENE_HEIGHT))
		line.rotation = deg_to_rad(-8)
		parent.add_child(line)
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

func _ui_file_texture(path: String, size := Vector2.ZERO, stretch := TextureRect.STRETCH_KEEP_ASPECT_CENTERED) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = AssetCatalog.load_texture(path)
	rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rect.stretch_mode = stretch
	rect.custom_minimum_size = size
	return rect

func _make_art_panel(texture_path: String, min_size: Vector2, padding := Vector4(34, 24, 34, 24)) -> VBoxContainer:
	var holder := Control.new()
	holder.custom_minimum_size = min_size
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	holder.clip_contents = true
	content.add_child(holder)

	var shell := PanelContainer.new()
	shell.set_anchors_preset(Control.PRESET_FULL_RECT)
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.add_theme_stylebox_override("panel", _panel_style(Color("#2a1a12"), Color("#6b4728"), 10))
	holder.add_child(shell)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", int(padding.x))
	margin.add_theme_constant_override("margin_top", int(padding.y))
	margin.add_theme_constant_override("margin_right", int(padding.z))
	margin.add_theme_constant_override("margin_bottom", int(padding.w))
	shell.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(box)
	return box

func _make_art_book(min_size := Vector2(0, 430)) -> HBoxContainer:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(max(min_size.x, 0.0), max(min_size.y, 460.0))
	holder.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	holder.size_flags_vertical = Control.SIZE_EXPAND_FILL
	holder.clip_contents = true
	content.add_child(holder)

	var shell := PanelContainer.new()
	shell.set_anchors_preset(Control.PRESET_FULL_RECT)
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.add_theme_stylebox_override("panel", _panel_style(Color("#28180f"), Color("#8f6a45"), 10))
	holder.add_child(shell)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.clip_contents = true
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_bottom", 20)
	shell.add_child(margin)

	var spread := HBoxContainer.new()
	spread.add_theme_constant_override("separation", 14)
	spread.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spread.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(spread)
	return spread

func _set_modal_input_locked(locked: bool) -> void:
	if bottom_panel != null:
		bottom_panel.modulate = Color(1, 1, 1, 0.42) if locked else Color.WHITE
		bottom_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE if locked else Control.MOUSE_FILTER_PASS

func _clear_overlay() -> void:
	if overlay_root == null:
		return
	for child in overlay_root.get_children():
		child.queue_free()

func _close_book_overlay() -> void:
	_clear_overlay()
	if overlay_root != null:
		overlay_root.visible = false
	_set_modal_input_locked(false)

func _open_book_overlay(texture_path: String) -> HBoxContainer:
	_clear_overlay()
	overlay_root.visible = true
	overlay_root.z_index = 4000
	_set_modal_input_locked(true)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.015, 0.01, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay_root.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_STOP
	overlay_root.add_child(center)

	var holder := Control.new()
	holder.custom_minimum_size = Vector2(1024, 700)
	holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	holder.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	holder.clip_contents = true
	center.add_child(holder)

	var shell := PanelContainer.new()
	shell.set_anchors_preset(Control.PRESET_FULL_RECT)
	shell.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shell.add_theme_stylebox_override("panel", _panel_style(Color("#28180f"), Color("#8f6a45"), 10))
	holder.add_child(shell)

	var page_margin := MarginContainer.new()
	page_margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	page_margin.clip_contents = true
	page_margin.add_theme_constant_override("margin_left", 22)
	page_margin.add_theme_constant_override("margin_top", 18)
	page_margin.add_theme_constant_override("margin_right", 22)
	page_margin.add_theme_constant_override("margin_bottom", 18)
	shell.add_child(page_margin)

	var book_box := VBoxContainer.new()
	book_box.add_theme_constant_override("separation", 8)
	book_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	book_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page_margin.add_child(book_box)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 8)
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	book_box.add_child(header)
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)
	var close_button := _button("Đóng sổ", _close_book_overlay)
	close_button.custom_minimum_size = Vector2(104, 34)
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_END
	header.add_child(close_button)

	var spread := HBoxContainer.new()
	spread.add_theme_constant_override("separation", 18)
	spread.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	spread.size_flags_vertical = Control.SIZE_EXPAND_FILL
	book_box.add_child(spread)
	return spread

func _book_page() -> PanelContainer:
	var page := PanelContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical = Control.SIZE_EXPAND_FILL
	page.custom_minimum_size = Vector2(338, 0)
	page.clip_contents = true
	page.add_theme_stylebox_override("panel", _panel_style(Color("#ead7ad"), Color("#8f6a45"), 6))

	var safe_margin := MarginContainer.new()
	safe_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	safe_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	safe_margin.clip_contents = true
	safe_margin.add_theme_constant_override("margin_left", 16)
	safe_margin.add_theme_constant_override("margin_right", 16)
	safe_margin.add_theme_constant_override("margin_top", 14)
	safe_margin.add_theme_constant_override("margin_bottom", 14)
	page.add_child(safe_margin)

	var body := VBoxContainer.new()
	body.add_theme_constant_override("separation", 8)
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.clip_contents = true
	safe_margin.add_child(body)
	return page

func _book_page_body(page: Control) -> VBoxContainer:
	if page == null:
		return VBoxContainer.new()
	if page.get_child_count() == 0:
		return VBoxContainer.new()
	var safe_margin := page.get_child(0)
	if safe_margin is MarginContainer and safe_margin.get_child_count() > 0:
		var body := safe_margin.get_child(0)
		if body is VBoxContainer:
			return body
	return VBoxContainer.new()

func _book_scroll(parent: Control) -> VBoxContainer:
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.clip_contents = true
	parent.add_child(scroll)

	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.clip_contents = true
	scroll.add_child(list)
	return list

func _book_content_box(parent: Control, separation := 8) -> VBoxContainer:
	var content_box := VBoxContainer.new()
	content_box.add_theme_constant_override("separation", separation)
	content_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_box.clip_contents = true
	parent.add_child(content_box)
	return content_box

func _panel_two_column_body(parent: Control, left_ratio := 1.1, right_ratio := 0.9, separation := 14) -> Dictionary:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", separation)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.clip_contents = true
	parent.add_child(row)

	var left := VBoxContainer.new()
	left.add_theme_constant_override("separation", 8)
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left.size_flags_stretch_ratio = left_ratio
	left.clip_contents = true
	row.add_child(left)

	var right := VBoxContainer.new()
	right.add_theme_constant_override("separation", 8)
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.size_flags_stretch_ratio = right_ratio
	right.clip_contents = true
	row.add_child(right)

	return {"row": row, "left": left, "right": right}

func _panel_button_grid(columns := 2, separation := 8) -> GridContainer:
	var grid := GridContainer.new()
	grid.columns = max(1, columns)
	grid.add_theme_constant_override("h_separation", separation)
	grid.add_theme_constant_override("v_separation", separation)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.clip_contents = true
	return grid

func _show_recipe_selection_overlay(selecting_menu: bool) -> void:
	recipe_selection_detail_root = null
	recipe_selection_summary_label = null
	recipe_selection_title_label = null
	recipe_selection_desc_label = null
	menu_selection_label = null
	recipe_selection_menu_list = _cookable_recipes()
	if recipe_book_selected_id == "" and not selecting_menu:
		var available := _available_recipes()
		if not available.is_empty():
			recipe_book_selected_id = str(available[0].get("id", ""))
		elif not data.get("recipes", []).is_empty():
			recipe_book_selected_id = str(data["recipes"][0].get("id", ""))

	var spread := _open_book_overlay("")
	var left := _book_page()
	spread.add_child(left)
	var left_body := _book_page_body(left)
	left_body.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BOWL_PATH], Color("#8f6a45")))
	left_body.add_child(_stage_label("Menu đêm" if selecting_menu else "Chọn món", Color("#3a2418"), 15))
	left_body.add_child(_stage_label("Chọn bằng một cú bấm rồi đọc ghi chú ở trang phải.", Color("#6b4728"), 10))

	var list := _book_scroll(left_body)
	var recipe_list := _available_recipes() if selecting_menu else recipe_selection_menu_list
	for recipe in recipe_list:
		var recipe_id := str(recipe.get("id", ""))
		var current_recipe_id := recipe_id
		var on_press := func():
			recipe_book_selected_id = current_recipe_id
			if selecting_menu:
				_toggle_menu_recipe(current_recipe_id)
			_refresh_recipe_selection_overlay(selecting_menu)
		var row_button := _book_card_button(
			list,
			"%s%s" % ["[x] " if selected_menu.has(recipe_id) else "[ ] ", str(recipe.get("name", "Món"))],
			"Ấm %s · Tỉnh %s · Dịu %s" % [
				int(recipe.get("warmth_level", 0)),
				int(recipe.get("caffeine_level", 0)),
				int(recipe.get("comfort_level", 0))
			],
			_recipe_ui_icon_path(recipe),
			Vector2(0, 68),
			on_press,
			Color("#ffd58a") if recipe_id == recipe_book_selected_id else Color("#ead7ad"),
			Color("#8f6a45"),
			Color("#3a2418"),
			Color("#7a4d31"),
			false
		)
		menu_recipe_buttons[current_recipe_id] = row_button
		_update_menu_recipe_button(current_recipe_id)

	var right := _book_page()
	spread.add_child(right)
	var right_body := _book_page_body(right)
	var selected_recipe := _recipe(recipe_book_selected_id)
	if selected_recipe.is_empty() and not selecting_menu and not recipe_selection_menu_list.is_empty():
		selected_recipe = _recipe(recipe_selection_menu_list[0])
	elif selected_recipe.is_empty() and not selecting_menu and not _available_recipes().is_empty():
		selected_recipe = _available_recipes()[0]
	right_body.add_child(_decor_icon_row([_recipe_ui_icon_path(selected_recipe), UI_ICON_CAKE_PATH, UI_ICON_BREAD_PATH], Color("#8f6a45")))
	recipe_selection_title_label = _stage_label(str(selected_recipe.get("name", "Chưa chọn món")), Color("#3a2418"), 16)
	right_body.add_child(recipe_selection_title_label)
	recipe_selection_desc_label = _stage_label(str(selected_recipe.get("description", "Bấm một món bên trái để xem ghi chú.")), Color("#6b4728"), 11)
	right_body.add_child(recipe_selection_desc_label)
	recipe_selection_detail_root = _book_content_box(right_body, 6)
	_refresh_recipe_selection_detail(selected_recipe)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 8)
	actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_body.add_child(actions)
	var primary_text := "Mở quán" if selecting_menu else "Nấu món này"
	var primary_button := _button(primary_text, func():
		_close_book_overlay()
		if selecting_menu:
			_start_night()
			return
		var active_recipe := _recipe(recipe_book_selected_id)
		if active_recipe.is_empty():
			active_recipe = selected_recipe
		if not active_recipe.is_empty():
			_show_cooking_panel(str(active_recipe.get("id", "")))
	)
	actions.add_child(primary_button)
	actions.add_child(_button("Quay lại", _close_book_overlay))

func _clear() -> void:
	for child in content.get_children():
		child.queue_free()
	for child in top_bar.get_children():
		child.queue_free()
	ui_text_parent = content

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
	_set_game_layout_mode("normal")
	_setup_top_bar(false)
	screen_history.clear()
	_start_ambience()
	_render_cafe_scene("menu")
	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 300)
	scroll.clip_contents = true
	content.add_child(scroll)

	var inner := VBoxContainer.new()
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inner.add_theme_constant_override("separation", 10)
	scroll.add_child(inner)
	ui_text_parent = inner
	_add_heading("Quán đã lên đèn.")
	_add_paragraph(data.get("game", {}).get("vision", ""))
	_add_paragraph("Bản demo tập trung vào 5 đêm đầu: mở quán, lắng nghe, chọn món đúng lúc, và ghi lại những gì khách để lại.")
	_add_main_menu_actions(inner, false)

func _new_game() -> void:
	_reset_state()
	_save_game()
	_show_prep()

func _add_main_menu_actions(parent: Control = null, wrap_scroll := true) -> void:
	var target := parent if parent != null else ui_text_parent if ui_text_parent != null else content
	var container: Control = target
	if wrap_scroll:
		var scroll := ScrollContainer.new()
		scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
		scroll.custom_minimum_size = Vector2(0, 300)
		scroll.clip_contents = true
		target.add_child(scroll)
		container = scroll

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	container.add_child(grid)

	var continue_button := _menu_action_button("Tiếp tục", "Mở lại đêm đang lưu", _load_game)
	continue_button.disabled = not FileAccess.file_exists(SAVE_PATH)
	grid.add_child(continue_button)
	grid.add_child(_menu_action_button("Chơi mới", "Bắt đầu lại từ đêm đầu", _new_game))
	grid.add_child(_menu_action_button("Cài đặt", "Âm lượng, ambience, cấu hình sprite", _show_settings))
	grid.add_child(_menu_action_button("Credits", "Nguồn asset và ghi chú license", _show_credits))
	grid.add_child(_menu_action_button("Thoát", "Đóng bản demo", func(): get_tree().quit()))

func _menu_action_button(title: String, subtitle: String, callable: Callable) -> Button:
	var button := _button("%s\n%s" % [title, subtitle], callable)
	button.custom_minimum_size = Vector2(0, 48)
	button.add_theme_font_size_override("font_size", int(round(12 * ui_scale)))
	button.add_theme_color_override("font_color", Color("#ffe8c2"))
	return button

func _show_decorate() -> void:
	var was_decorate := decorate_mode
	decorate_mode = true
	if not was_decorate:
		decorate_tool = ""
	decorate_selected_background = _current_decor_background_path()
	decorate_selected_chef = _current_decor_chef_id()
	if decorate_return_scene.is_empty():
		decorate_return_scene = {
			"mode": current_scene_mode,
			"customer_id": current_scene_customer_id,
			"recipe_id": current_scene_recipe_id,
			"result": current_scene_result,
			"animate_entry": current_scene_animate_entry
		}
	_clear()
	_set_game_layout_mode("normal")
	_render_cafe_scene("decorate")
	_setup_top_bar(true)

	var panel := _make_art_panel("", Vector2(0, 390), Vector4(30, 16, 30, 16))
	var body := _book_content_box(panel, 10)
	body.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BOWL_PATH], Color("#8f6a45")))
	body.add_child(_stage_label("Trang trí quán", Color("#ffd58a"), 22))
	body.add_child(_stage_label("Chọn nền, chef, props và bấm Đặt ghế / Đặt prop rồi click lên scene.", Color("#f2e6ce"), 14))

	var columns := _panel_two_column_body(body, 1.03, 0.97, 14)
	var left := columns["left"] as VBoxContainer
	var right := columns["right"] as VBoxContainer

	left.add_child(_stage_label("Background", Color("#f7eddc"), 18))
	var bg_grid := _panel_button_grid(1, 8)
	left.add_child(bg_grid)
	for bg in _decorate_background_options():
		var bg_path := str(bg.get("path", SCENE_BACKDROP_PATH))
		var bg_title := str(bg.get("title", "Background"))
		var bg_meta := bg_path.get_file()
		var bg_active := bg_path == decorate_selected_background
		var current_bg_path := bg_path
		var bg_button := _book_card_button(bg_grid, bg_title, bg_meta, UI_ICON_CAKE_PATH, Vector2(0, 56), func():
			_set_decor_background(current_bg_path)
			decorate_selected_background = current_bg_path
			_show_decorate()
		, Color("#f0dfbb") if bg_active else Color("#ead7ad"), Color("#8f6a45"), Color("#3a2418") if bg_active else Color("#6b4728"), Color("#7a4d31"))
		bg_button.custom_minimum_size = Vector2(0, 56)

	left.add_child(_stage_label("Chef", Color("#f7eddc"), 18))
	var chef_grid := _panel_button_grid(1, 8)
	left.add_child(chef_grid)
	for chef_id in _decorate_chef_options():
		var cfg := _character_config(chef_id)
		var chef_name := str(cfg.get("name", chef_id))
		var chef_meta := str(cfg.get("short_description", chef_id))
		var chef_active := chef_id == decorate_selected_chef
		var current_chef_id := chef_id
		var chef_button := _book_card_button(chef_grid, chef_name, chef_meta, _customer_sprite_path(chef_id), Vector2(0, 58), func():
			_set_decor_chef(current_chef_id)
			decorate_selected_chef = current_chef_id
			_show_decorate()
		, Color("#f0dfbb") if chef_active else Color("#ead7ad"), Color("#8f6a45"), Color("#3a2418") if chef_active else Color("#6b4728"), Color("#7a4d31"))
		chef_button.custom_minimum_size = Vector2(0, 58)

	right.add_child(_stage_label("Props & items", Color("#f7eddc"), 18))
	var prop_filter := LineEdit.new()
	prop_filter.placeholder_text = "Tìm props theo tên..."
	prop_filter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(prop_filter)
	var prop_scroll := ScrollContainer.new()
	prop_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prop_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	prop_scroll.custom_minimum_size = Vector2(0, 210)
	prop_scroll.clip_contents = true
	right.add_child(prop_scroll)
	var prop_list := VBoxContainer.new()
	prop_list.add_theme_constant_override("separation", 8)
	prop_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prop_scroll.add_child(prop_list)

	var prop_paths := _decorative_asset_paths()
	var populate_props := func() -> void:
		for child in prop_list.get_children():
			child.queue_free()
		var query := prop_filter.text.strip_edges().to_lower()
		for path in prop_paths:
			var label := path.get_file().get_basename()
			if query != "" and label.to_lower().find(query) == -1 and path.to_lower().find(query) == -1:
				continue
			var icon_path := UI_ICON_PLATE_PATH
			if path.to_lower().find("coffee") != -1:
				icon_path = UI_ICON_COFFEE_PATH
			elif path.to_lower().find("tea") != -1:
				icon_path = UI_ICON_TEA_PATH
			elif path.to_lower().find("bread") != -1 or path.to_lower().find("toast") != -1:
				icon_path = UI_ICON_BREAD_PATH
			elif path.to_lower().find("cake") != -1:
				icon_path = UI_ICON_CAKE_PATH
			elif path.to_lower().find("bowl") != -1 or path.to_lower().find("plate") != -1:
				icon_path = UI_ICON_BOWL_PATH
			var prop_active := path == decorate_selected_prop
			var prop_path := path
			var prop_button := _book_card_button(prop_list, label, path.get_file(), icon_path, Vector2(0, 54), func():
				decorate_selected_prop = prop_path
				_show_decorate()
			, Color("#f0dfbb") if prop_active else Color("#ead7ad"), Color("#8f6a45"), Color("#3a2418") if prop_active else Color("#6b4728"), Color("#7a4d31"))
			prop_button.custom_minimum_size = Vector2(0, 54)

	populate_props.call()
	prop_filter.text_changed.connect(func(_text: String):
		populate_props.call()
	)

	var action_row := _panel_button_grid(3, 8)
	action_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(action_row)
	action_row.add_child(_button("Đặt ghế", func():
		decorate_tool = "seat"
		_show_decorate()
	))
	action_row.add_child(_button("Đặt prop", func():
		decorate_tool = "prop"
		_show_decorate()
	))
	action_row.add_child(_button("Xong", func():
		_finish_decorate()
	))

	var hint := "Click lên scene để đặt ghế cho khách" if decorate_tool == "seat" else "Click lên scene để thả prop" if decorate_tool == "prop" else "Chọn công cụ ở dưới rồi click vào quán."
	right.add_child(_stage_label(hint, Color("#b8d7c5"), 14))

func _finish_decorate() -> void:
	decorate_mode = false
	decorate_tool = ""
	if not decorate_return_scene.is_empty():
		var return_mode := str(decorate_return_scene.get("mode", "menu"))
		_render_cafe_scene(
			return_mode,
			str(decorate_return_scene.get("customer_id", "")),
			str(decorate_return_scene.get("recipe_id", "")),
			str(decorate_return_scene.get("result", "")),
			bool(decorate_return_scene.get("animate_entry", false))
		)
		if return_mode == "menu":
			_setup_top_bar(false)
		else:
			_setup_top_bar(true)
		decorate_return_scene = {}
	else:
		_show_main_menu()

func _show_settings() -> void:
	_clear()
	_set_game_layout_mode("normal")
	_setup_top_bar(false)
	_render_cafe_scene("settings")
	var inner := VBoxContainer.new()
	inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner.size_flags_vertical = Control.SIZE_EXPAND_FILL
	inner.add_theme_constant_override("separation", 12)
	content.add_child(inner)

	inner.add_child(_settings_heading("Cài đặt"))
	inner.add_child(_settings_paragraph("Các thanh âm lượng là hướng UI cho bản demo public. Hiện tại bản này đã có ambience mưa thị giác, audio thật sẽ được gắn ở phase sau."))
	inner.add_child(_settings_slider_row("Âm lượng nhạc", 58))
	inner.add_child(_settings_slider_row("Âm lượng ambience", 72))
	inner.add_child(_settings_slider_row("Tốc độ thoại", 62))
	var ambience_button := _button("Bật/tắt hiệu ứng mưa: %s" % ("BẬT" if ambience_enabled else "TẮT"), func():
		ambience_enabled = not ambience_enabled
		for line in rain_lines:
			line.visible = ambience_enabled
		_show_settings()
	)
	inner.add_child(ambience_button)
	var resolution_row := VBoxContainer.new()
	resolution_row.add_theme_constant_override("separation", 6)
	resolution_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner.add_child(resolution_row)
	resolution_row.add_child(_stage_label("Resolution preset", Color("#ffdca2"), 16))
	resolution_row.add_child(_stage_label("Cố định: 1280x720", Color("#f1d8a0"), 14))
	inner.add_child(_button("Cửa sổ cố định", func():
		_apply_resolution_preset("1280x720")
		_save_ui_settings()
	))
	_add_sprite_slice_settings_panel_to(inner)
	inner.add_child(_button("Quay lại", _show_main_menu))

func _settings_heading(text: String) -> Label:
	var label := _stage_label(text, Color("#fff2cf"), 24)
	label.clip_contents = true
	return label

func _settings_paragraph(text: String) -> Label:
	var label := _stage_label(text, Color("#f4e6d5"), 18)
	label.clip_contents = true
	return label

func _settings_slider_row(label_text: String, value: float) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 14)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var label := _stage_label(label_text, Color("#fff0d7"), 15)
	label.custom_minimum_size = Vector2(180, 34)
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = 0
	slider.max_value = 100
	slider.value = value
	slider.step = 1
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(slider)
	return row

func _add_sprite_slice_settings_panel_to(parent: VBoxContainer) -> void:
	cached_16x16_asset_paths.clear()
	var asset_paths := _collect_png_asset_paths()
	if selected_slice_texture == "":
		selected_slice_texture = _default_slice_texture(asset_paths)

	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#2a1a12"), Color("#d7a64b"), 8))
	parent.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(box)

	box.add_child(_stage_label("Cấu hình slice sprite asset", Color("#ffd58a"), 21))
	box.add_child(_stage_label("Chỉ áp dụng cho PNG thuộc pack /16x16/. Chỉnh xong là preview và preset cập nhật ngay.", Color("#f4e6d5"), 15))

	var asset_picker_box := VBoxContainer.new()
	asset_picker_box.add_theme_constant_override("separation", 6)
	asset_picker_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(asset_picker_box)

	var asset_picker_label := _stage_label("Danh sách PNG asset", Color("#f1d8a0"), 14)
	asset_picker_box.add_child(asset_picker_label)
	var asset_picker_overlay := Control.new()
	asset_picker_overlay.visible = false
	asset_picker_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	asset_picker_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	var popup_parent: Node = overlay_layer if overlay_layer != null else self
	popup_parent.add_child(asset_picker_overlay)
	settings_asset_picker_overlay = asset_picker_overlay
	var asset_picker_center := CenterContainer.new()
	asset_picker_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	asset_picker_center.mouse_filter = Control.MOUSE_FILTER_STOP
	asset_picker_overlay.add_child(asset_picker_center)
	var asset_picker_popup := PanelContainer.new()
	asset_picker_popup.custom_minimum_size = Vector2(920, 560)
	asset_picker_popup.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	asset_picker_popup.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	asset_picker_popup.add_theme_stylebox_override("panel", _panel_style(Color("#1f140e"), Color("#d7a64b"), 6))
	asset_picker_popup.mouse_filter = Control.MOUSE_FILTER_STOP
	asset_picker_center.add_child(asset_picker_popup)
	var populate_asset_list: Callable = Callable()

	var asset_picker_button := _button(selected_slice_texture.get_file(), func():
		if settings_asset_picker_filter != null:
			settings_asset_picker_filter.text = ""
		if populate_asset_list.is_valid():
			populate_asset_list.call()
		if asset_picker_overlay.visible:
			asset_picker_overlay.hide()
		else:
			asset_picker_overlay.show()
		)
	asset_picker_button.custom_minimum_size = Vector2(0, 38)
	asset_picker_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_picker_box.add_child(asset_picker_button)
	settings_asset_picker_button = asset_picker_button

	var asset_picker_margin := MarginContainer.new()
	asset_picker_margin.add_theme_constant_override("margin_left", 10)
	asset_picker_margin.add_theme_constant_override("margin_right", 10)
	asset_picker_margin.add_theme_constant_override("margin_top", 10)
	asset_picker_margin.add_theme_constant_override("margin_bottom", 10)
	asset_picker_popup.add_child(asset_picker_margin)

	var asset_picker_box_inner := VBoxContainer.new()
	asset_picker_box_inner.add_theme_constant_override("separation", 8)
	asset_picker_box_inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_picker_box_inner.size_flags_vertical = Control.SIZE_EXPAND_FILL
	asset_picker_margin.add_child(asset_picker_box_inner)

	var asset_picker_top := HBoxContainer.new()
	asset_picker_top.add_theme_constant_override("separation", 8)
	asset_picker_top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_picker_box_inner.add_child(asset_picker_top)
	settings_asset_picker_filter = LineEdit.new()
	settings_asset_picker_filter.placeholder_text = "Tìm asset theo tên chứa..."
	settings_asset_picker_filter.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_picker_top.add_child(settings_asset_picker_filter)
	settings_asset_picker_usage = _stage_label("Chưa dùng trong scene", Color("#f4e6d5"), 12)
	settings_asset_picker_usage.custom_minimum_size = Vector2(200, 0)
	asset_picker_top.add_child(settings_asset_picker_usage)

	var asset_scroll := ScrollContainer.new()
	asset_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	asset_scroll.follow_focus = true
	asset_scroll.custom_minimum_size = Vector2(0, 320)
	asset_picker_box_inner.add_child(asset_scroll)

	var asset_list := ItemList.new()
	asset_list.select_mode = ItemList.SELECT_SINGLE
	asset_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	asset_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	asset_list.max_columns = 1
	asset_list.fixed_icon_size = Vector2i(0, 0)
	asset_scroll.add_child(asset_list)
	settings_asset_picker_list = asset_list
	asset_picker_overlay.gui_input.connect(func(event: InputEvent):
		if not asset_picker_overlay.visible:
			return
		if event is InputEventMouseButton and event.pressed:
			var mouse_pos := get_viewport().get_mouse_position()
			if not asset_picker_popup.get_global_rect().has_point(mouse_pos):
				asset_picker_overlay.hide()
	)

	var texture_path_edit := LineEdit.new()
	texture_path_edit.text = selected_slice_texture
	texture_path_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(_labeled_control("Đường dẫn asset đang chọn", texture_path_edit))

	var texture_info := Label.new()
	texture_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texture_info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texture_info.add_theme_font_size_override("font_size", 12)
	texture_info.add_theme_color_override("font_color", Color("#f4e6d5"))
	texture_info.add_theme_color_override("font_outline_color", Color("#1b1009"))
	texture_info.add_theme_constant_override("outline_size", 2)
	box.add_child(texture_info)

	var preview_host := VBoxContainer.new()
	preview_host.add_theme_constant_override("separation", 8)
	preview_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(preview_host)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 10)
	grid.add_theme_constant_override("v_separation", 6)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(grid)

	var frame_width_spin := _settings_spin(grid, "Frame width", 1, 512, 16)
	var frame_height_spin := _settings_spin(grid, "Frame height", 1, 512, 16)
	var start_frame_spin := _settings_spin(grid, "Start frame", 0, 9999, 0)
	var slice_count_spin := _settings_spin(grid, "Slice count (0 = auto)", 0, 9999, 0)
	var fps_spin := _settings_spin(grid, "FPS", 1, 60, 4)
	var offset_x_spin := _settings_spin(grid, "Offset X", -1024, 1024, 0)
	var offset_y_spin := _settings_spin(grid, "Offset Y", -1024, 1024, 0)

	var loop_check := CheckBox.new()
	loop_check.text = "Loop animation"
	loop_check.button_pressed = true
	loop_check.add_theme_color_override("font_color", Color("#f1d8a0"))
	grid.add_child(loop_check)

	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 10)
	actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(actions)

	var info_path := func() -> String:
		return texture_path_edit.text.strip_edges()

	populate_asset_list = func() -> void:
		asset_list.clear()
		var query := ""
		if settings_asset_picker_filter != null:
			query = settings_asset_picker_filter.text.strip_edges().to_lower()
		var used_assets := _scene_used_asset_paths()
		var added_count := 0
		for path in asset_paths:
			var label := path.get_file()
			if query != "" and label.to_lower().find(query) == -1 and path.to_lower().find(query) == -1:
				continue
			var display_label := "[X] %s" % label if used_assets.has(path) else "[ ] %s" % label
			var item_index := asset_list.add_item(display_label)
			asset_list.set_item_metadata(item_index, path)
			if path == selected_slice_texture:
				asset_list.select(item_index)
			added_count += 1
		asset_list.custom_minimum_size = Vector2(0, 420)
		if settings_asset_picker_usage != null:
			settings_asset_picker_usage.text = "Đang chọn: %s · %s asset" % [selected_slice_texture.get_file(), added_count]

	var refresh_preview := func() -> void:
		var path: String = info_path.call()
		texture_path_edit.text = path
		texture_info.text = "Chưa load được texture."
		for child in preview_host.get_children():
			child.queue_free()
		var texture: Texture2D = AssetCatalog.load_texture(path)
		if texture == null:
			texture_info.add_theme_color_override("font_color", Color("#ff9b8a"))
			return
		var frame_width: int = max(1, int(frame_width_spin.value))
		var frame_height: int = max(1, int(frame_height_spin.value))
		var start_frame: int = max(0, int(start_frame_spin.value))
		var slice_count: int = int(slice_count_spin.value)
		var preset_live: Dictionary = _sprite_slice_preset_live(path)
		texture_info.add_theme_color_override("font_color", Color("#b8d7c5"))
		texture_info.text = "Kích thước ảnh: %sx%s. Preset live: %sx%s, start %s, slice %s, offset %s/%s." % [
			texture.get_width(),
			texture.get_height(),
			frame_width,
			frame_height,
			start_frame,
			"auto" if slice_count <= 0 else str(slice_count),
			int(preset_live.get("offset_x", 0)),
			int(preset_live.get("offset_y", 0))
		]
		preview_host.add_child(_sprite_slice_preview(path, texture, frame_width, frame_height, start_frame))
		preview_host.add_child(_stage_label("Offset sẽ phản ánh ngay vào scene đang mở.", Color("#a8c8b4"), 12))

	var sync_live := func(save_now := false) -> void:
		var path: String = info_path.call()
		if path == "":
			return
		selected_slice_texture = path
		var preset: Dictionary = _sprite_slice_preset_live(path)
		preset["animation_name"] = "loop"
		preset["fps"] = int(fps_spin.value)
		preset["frame_height"] = int(frame_height_spin.value)
		preset["frame_width"] = int(frame_width_spin.value)
		preset["offset_x"] = int(offset_x_spin.value)
		preset["offset_y"] = int(offset_y_spin.value)
		preset["loop"] = loop_check.button_pressed
		preset["slice_count"] = int(slice_count_spin.value)
		preset["start_frame"] = int(start_frame_spin.value)
		preset["output_path"] = "res://assets/spriteframes/%s_%sx%s_%s.tres" % [
			path.get_file().get_basename(),
			int(frame_width_spin.value),
			int(frame_height_spin.value),
			int(slice_count_spin.value)
		]
		sprite_slice_presets[path] = preset
		refresh_preview.call()
		_refresh_current_scene()
		if save_now:
			_save_sprite_slice_presets()

	var sync_selection := func(path: String, save_now := false) -> void:
		var safe_path: String = path.strip_edges()
		if safe_path == "":
			return
		selected_slice_texture = safe_path
		texture_path_edit.text = safe_path
		asset_picker_button.text = safe_path.get_file()
		var preset: Dictionary = _sprite_slice_preset_live(safe_path)
		frame_width_spin.value = int(preset.get("frame_width", 16))
		frame_height_spin.value = int(preset.get("frame_height", 16))
		start_frame_spin.value = int(preset.get("start_frame", 0))
		slice_count_spin.value = int(preset.get("slice_count", 0))
		fps_spin.value = int(preset.get("fps", 4))
		offset_x_spin.value = int(preset.get("offset_x", 0))
		offset_y_spin.value = int(preset.get("offset_y", 0))
		loop_check.button_pressed = bool(preset.get("loop", true))
		refresh_preview.call()
		_refresh_current_scene()
		if save_now:
			sync_live.call(true)

	asset_list.item_selected.connect(func(index: int):
		var path: String = str(asset_list.get_item_metadata(index))
		asset_picker_overlay.hide()
		sync_selection.call(path, true)
	)
	if settings_asset_picker_filter != null:
		settings_asset_picker_filter.text_changed.connect(func(_text: String):
			if populate_asset_list.is_valid():
				populate_asset_list.call()
		)
	texture_path_edit.text_changed.connect(func(text: String):
		var path: String = text.strip_edges()
		if path == "":
			texture_info.add_theme_color_override("font_color", Color("#ff9b8a"))
			texture_info.text = "Hãy nhập đường dẫn asset."
			for child in preview_host.get_children():
				child.queue_free()
			return
		selected_slice_texture = path
		asset_picker_button.text = path.get_file()
		refresh_preview.call()
		sync_live.call(false)
		_refresh_current_scene()
	)
	texture_path_edit.text_submitted.connect(func(_text: String):
		sync_live.call(true)
	)
	frame_width_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	frame_height_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	start_frame_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	slice_count_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	fps_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
	)
	offset_x_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	offset_y_spin.value_changed.connect(func(_value: float):
		sync_live.call(false)
		_refresh_current_scene()
	)
	loop_check.toggled.connect(func(_pressed: bool):
		sync_live.call(false)
	)

	actions.add_child(_button("Lưu preset slice", func():
		sync_live.call(true)
		_refresh_current_scene()
	))
	actions.add_child(_button("Add assets to scene", func():
		var path: String = info_path.call()
		if path == "":
			return
		_place_asset_in_scene(path)
	))
	actions.add_child(_button("Remove assets from scene", func():
		var path: String = info_path.call()
		if path == "":
			return
		_remove_asset_from_scene(path)
	))
	actions.add_child(_button("Set as original", func():
		var path: String = info_path.call()
		if path == "":
			return
		var preset: Dictionary = _sprite_slice_preset_live(path)
		var current_offset_x := int(offset_x_spin.value)
		var current_offset_y := int(offset_y_spin.value)
		preset["original_offset_x"] = int(preset.get("original_offset_x", 0)) + current_offset_x
		preset["original_offset_y"] = int(preset.get("original_offset_y", 0)) + current_offset_y
		offset_x_spin.value = 0
		offset_y_spin.value = 0
		preset["offset_x"] = 0
		preset["offset_y"] = 0
		sprite_slice_presets[path] = preset
		refresh_preview.call()
		_refresh_current_scene()
		_save_sprite_slice_presets()
	))
	actions.add_child(_button("Xóa preset asset này", func():
		var path: String = info_path.call()
		if sprite_slice_presets.has(path):
			sprite_slice_presets.erase(path)
			_save_sprite_slice_presets()
		sync_selection.call(_default_slice_texture(asset_paths), true)
		_refresh_current_scene()
		_show_settings()
	))
	sync_selection.call(selected_slice_texture, false)
	asset_picker_button.text = selected_slice_texture.get_file()
	populate_asset_list.call()
	asset_picker_overlay.hide()

func _collect_png_asset_paths() -> Array[String]:
	if not cached_16x16_asset_paths.is_empty():
		return cached_16x16_asset_paths.duplicate()
	var results: Array[String] = []
	var seen := {}
	for root_path in [
		"res://assets",
		"D:/GameMaking/game assets",
		"D:/GameMaking/idea-ready-game/assets"
	]:
		_collect_png_asset_paths_recursive(root_path, results, false)
	var deduped: Array[String] = []
	for path in results:
		if not seen.has(path):
			seen[path] = true
			deduped.append(path)
	results = deduped
	results.sort()
	cached_16x16_asset_paths = results.duplicate()
	return results

func _scene_used_asset_paths() -> Dictionary:
	var used: Dictionary = {}
	if scene_layer != null:
		_collect_scene_used_asset_paths(scene_layer, used)
	return used

func _collect_scene_used_asset_paths(node: Node, used: Dictionary) -> void:
	if node == null:
		return
	if node.has_meta("asset_path"):
		_add_used_asset_meta(used, node.get_meta("asset_path"))
	if node.has_meta("asset_path_alt"):
		_add_used_asset_meta(used, node.get_meta("asset_path_alt"))
	if node is TextureRect:
		_add_used_texture_path(used, (node as TextureRect).texture)
	elif node is Sprite2D:
		_add_used_texture_path(used, (node as Sprite2D).texture)
	elif node is AnimatedSprite2D:
		var animated := node as AnimatedSprite2D
		if animated.sprite_frames != null:
			for animation_name in animated.sprite_frames.get_animation_names():
				var count := animated.sprite_frames.get_frame_count(animation_name)
				for i in range(count):
					_add_used_texture_path(used, animated.sprite_frames.get_frame_texture(animation_name, i))
	for child in node.get_children():
		if child is Node:
			_collect_scene_used_asset_paths(child, used)

func _add_used_asset_meta(used: Dictionary, value) -> void:
	if value is Array:
		for item in value:
			_add_used_asset_meta(used, item)
		return
	var path := str(value).strip_edges()
	if path != "":
		used[path] = true

func _add_used_texture_path(used: Dictionary, texture) -> void:
	if texture == null:
		return
	if texture is AtlasTexture and (texture as AtlasTexture).atlas != null:
		var atlas := texture as AtlasTexture
		_add_used_texture_path(used, atlas.atlas)
		return
	if texture is Texture2D:
		var path := str((texture as Texture2D).resource_path).strip_edges()
		if path != "":
			used[path] = true

func _collect_png_asset_paths_recursive(dir_path: String, results: Array[String], include_all_pngs: bool = false) -> void:
	var normalized_dir := dir_path
	if not normalized_dir.begins_with("res://") and not normalized_dir.begins_with("user://") and not normalized_dir.is_absolute_path():
		normalized_dir = ProjectSettings.globalize_path(normalized_dir)
	var dir := DirAccess.open(normalized_dir)
	if dir == null:
		return
	dir.list_dir_begin()
	while true:
		var name := dir.get_next()
		if name == "":
			break
		if name.begins_with("."):
			continue
		var path := "%s/%s" % [normalized_dir, name]
		if dir.current_is_dir():
			_collect_png_asset_paths_recursive(path, results, include_all_pngs)
		elif name.get_extension().to_lower() == "png":
			if include_all_pngs or normalized_dir.to_lower().find("16x16") != -1:
				results.append(path)
	dir.list_dir_end()

func _default_slice_texture(asset_paths: Array[String]) -> String:
	var cat_path := AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cat.png"
	if asset_paths.has(cat_path):
		return cat_path
	if not sprite_slice_presets.is_empty():
		return str(sprite_slice_presets.keys()[0])
	return asset_paths[0] if not asset_paths.is_empty() else cat_path

func _sprite_slice_preview(path: String, texture: Texture2D, frame_width: int, frame_height: int, start_frame: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var preview := TextureRect.new()
	preview.custom_minimum_size = Vector2(80, 80)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST

	if frame_width > 0 and frame_height > 0 and texture.get_width() % frame_width == 0 and texture.get_height() % frame_height == 0:
		var columns: int = max(1, int(texture.get_width() / frame_width))
		var total_frames: int = columns * max(1, int(texture.get_height() / frame_height))
		var safe_frame: int = clampi(start_frame, 0, max(0, total_frames - 1))
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(
			(safe_frame % columns) * frame_width,
			int(safe_frame / columns) * frame_height,
			frame_width,
			frame_height
		)
		preview.texture = atlas
		row.add_child(preview)
		row.add_child(_stage_label("Preview frame %s của %s" % [safe_frame, path.get_file()], Color("#f1d8a0"), 13))
	else:
		preview.texture = texture
		row.add_child(preview)
		row.add_child(_stage_label("Frame size chưa chia hết texture. Hãy chỉnh width/height rồi lưu.", Color("#ff9b8a"), 13))
	return row

func _settings_spin(parent: Control, label_text: String, min_value: int, max_value: int, default_value: int) -> SpinBox:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	var label := _stage_label(label_text, Color("#f1d8a0"), 13)
	box.add_child(label)
	var spin := SpinBox.new()
	spin.min_value = min_value
	spin.max_value = max_value
	spin.step = 1
	spin.value = default_value
	spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(spin)
	parent.add_child(box)
	return spin

func _labeled_control(label_text: String, control: Control) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	var label := _stage_label(label_text, Color("#f1d8a0"), 13)
	box.add_child(label)
	box.add_child(control)
	return box

func _save_sprite_slice_presets() -> void:
	var dir := SPRITE_SLICE_PRESET_PATH.get_base_dir()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var file := FileAccess.open(SPRITE_SLICE_PRESET_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Cannot write sprite slice presets: %s" % SPRITE_SLICE_PRESET_PATH)
		return
	file.store_string(JSON.stringify(sprite_slice_presets, "\t"))
	file.close()

func _sprite_slice_preset_live(path: String) -> Dictionary:
	var preset: Dictionary = sprite_slice_presets.get(path, {}).duplicate(true)
	if preset.is_empty():
		preset = {
			"animation_name": "loop",
			"fps": 4,
			"frame_height": 16,
			"frame_width": 16,
			"loop": true,
			"offset_x": 0,
			"offset_y": 0,
			"original_offset_x": 0,
			"original_offset_y": 0,
			"output_path": "res://assets/spriteframes/%s_16x16.tres" % path.get_file().get_basename(),
			"slice_count": 0,
			"start_frame": 0
		}
	else:
		if not preset.has("original_offset_x"):
			preset["original_offset_x"] = 0
		if not preset.has("original_offset_y"):
			preset["original_offset_y"] = 0
	return preset

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
	_set_game_layout_mode("book")
	_setup_top_bar(true)
	current_night_index = int(state["current_night"]) - 1
	if current_night_index >= data["nights"].size():
		_show_demo_ending()
		return
	_unlock_recipes_for_current_night()
	selected_menu.clear()
	menu_recipe_buttons.clear()
	menu_selection_label = null
	var night: Dictionary = data["nights"][current_night_index]
	_render_cafe_scene("prep")
	_add_heading("Trước khi mở quán")
	_add_meta("%s · %s" % [night["date_label"], night["weather"]])
	_add_paragraph(night["opening_text"])
	_add_subheading("Việc chuẩn bị nhẹ")
	for note in night.get("prep_notes", []):
		_add_bullet(note)
	_add_subheading("Chọn vài món nổi bật cho menu đêm nay")
	_add_paragraph("Chọn menu sẽ mở trong quyển sổ giữa màn hình. Phần dưới chỉ còn vai trò dẫn chuyện.")
	_add_note("Menu đêm nay: chọn tối đa 5 món. Quyển menu sẽ mở ở giữa màn hình.")
	_show_recipe_selection_overlay(true)

func _toggle_menu_recipe(recipe_id: String) -> void:
	if selected_menu.has(recipe_id):
		selected_menu.erase(recipe_id)
	elif selected_menu.size() < 5:
		selected_menu.append(recipe_id)
	for key in menu_recipe_buttons.keys():
		_update_menu_recipe_button(str(key))
	_refresh_menu_selection_label()

func _start_night() -> void:
	if selected_menu.is_empty():
		_assign_random_menu_recipes()
	current_visit_index = 0
	_show_next_customer()

func _assign_random_menu_recipes() -> void:
	var available := _available_recipes()
	if available.is_empty():
		return
	var pool := available.duplicate()
	pool.shuffle()
	selected_menu.clear()
	for recipe in pool.slice(0, min(5, pool.size())):
		selected_menu.append(str(recipe.get("id", "")))

func _show_next_customer() -> void:
	var night: Dictionary = data["nights"][current_night_index]
	if current_visit_index >= night["visits"].size():
		_show_closing()
		return
	current_visit = night["visits"][current_visit_index]
	current_scene_walk_in_customer_id = str(current_visit.get("customer_id", "")) if bool(current_visit.get("animate_entry", false)) else ""
	current_choice = {}
	_clear()
	_set_game_layout_mode("dialogue")
	_setup_top_bar(true)
	var customer := _customer(current_visit["customer_id"])
	_render_cafe_scene("dialogue", str(current_visit["customer_id"]), "", "", true)
	_show_dialogue_bottom_panel(customer)

func _show_dialogue_bottom_panel(customer: Dictionary, extra_lines: Array[String] = [], extra_hint := "") -> void:
	var panel := _make_art_panel("", Vector2(0, 236), Vector4(30, 16, 30, 16))
	var body := _book_content_box(panel, 8)
	body.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BOWL_PATH], Color("#8f6a45")))
	var columns := _panel_two_column_body(body, 1.12, 0.88, 16)
	var left := columns["left"] as VBoxContainer
	var right := columns["right"] as VBoxContainer

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(head)
	head.add_child(_dialogue_avatar(str(current_visit.get("customer_id", ""))))
	var head_text := VBoxContainer.new()
	head_text.add_theme_constant_override("separation", 4)
	head_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(head_text)
	head_text.add_child(_stage_label("%s bước vào" % str(customer.get("name", "Khách")), Color("#f7eddc"), 24))
	head_text.add_child(_stage_label("%s · %s" % [str(customer.get("short_description", "")), str(current_visit.get("mood", ""))], Color("#f2e6ce"), 16))
	head_text.add_child(_stage_label(str(current_visit.get("arrival", "")), Color("#e8ddc9"), 14))

	var story_box := VBoxContainer.new()
	story_box.add_theme_constant_override("separation", 4)
	story_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(story_box)
	for line in _compact_lines(current_visit.get("lines", []), 2):
		story_box.add_child(_stage_label("“%s”" % str(line), Color("#fff6e6"), 18))
	for line in _compact_lines(extra_lines, 1):
		story_box.add_child(_stage_label(str(line), Color("#f2e6ce"), 16))
	if extra_hint != "":
		story_box.add_child(_stage_label(extra_hint, Color("#eadfc7"), 15))

	right.add_child(_stage_label("Chọn cách đáp", Color("#f7eddc"), 20))
	right.add_child(_stage_label("Giữ khung gọn, chọn nhanh rồi quay lại nhìn quán.", Color("#f2e6ce"), 14))
	var choices_grid := _panel_button_grid(2, 8)
	choices_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(choices_grid)
	for choice in current_visit.get("choices", []):
		var choice_data: Dictionary = choice
		var option := _button(str(choice.get("text", "Chọn")), func():
			_choose_dialogue(choice_data)
		)
		option.custom_minimum_size = Vector2(0, 44)
		option.add_theme_font_size_override("font_size", 12)
		choices_grid.add_child(option)

func _choose_dialogue(choice: Dictionary) -> void:
	current_choice = choice
	if choice.has("note"):
		_add_customer_note(current_visit["customer_id"], choice["note"])
	_clear()
	_set_game_layout_mode("dialogue")
	_setup_top_bar(true)
	_render_cafe_scene("dialogue", str(current_visit.get("customer_id", "")))
	var customer := _customer(current_visit.get("customer_id", ""))
	var panel := _make_art_panel("", Vector2(0, 236), Vector4(30, 16, 30, 16))
	var body := _book_content_box(panel, 8)
	body.add_child(_decor_icon_row([UI_ICON_CAKE_PATH, UI_ICON_BREAD_PATH, UI_ICON_COFFEE_PATH], Color("#8f6a45")))
	var columns := _panel_two_column_body(body, 1.12, 0.88, 12)
	var left := columns["left"] as VBoxContainer
	var right := columns["right"] as VBoxContainer

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(head)
	head.add_child(_dialogue_avatar(str(current_visit.get("customer_id", ""))))
	var head_text := VBoxContainer.new()
	head_text.add_theme_constant_override("separation", 4)
	head_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(head_text)
	head_text.add_child(_stage_label("%s nghe xong rồi." % str(customer.get("name", "Khách")), Color("#f7eddc"), 23))
	head_text.add_child(_stage_label(str(choice.get("response", "")), Color("#fff6e6"), 16))

	var reaction_box := VBoxContainer.new()
	reaction_box.add_theme_constant_override("separation", 4)
	reaction_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(reaction_box)
	reaction_box.add_child(_stage_label("Khách chờ món kế tiếp.", Color("#f2e6ce"), 14))
	for line in _compact_lines(choice.get("followup", []), 2):
		reaction_box.add_child(_stage_label("• %s" % str(line), Color("#fff6e6"), 14))

	right.add_child(_stage_label("Tiếp theo", Color("#f7eddc"), 20))
	right.add_child(_stage_label("Chọn món đúng đêm này rồi quay lại câu chuyện.", Color("#f2e6ce"), 14))
	var response_actions := _panel_button_grid(2, 8)
	right.add_child(response_actions)
	var open_menu_btn := _button("Mở menu món cho khách", func():
		_show_recipe_selection_overlay(false)
	)
	open_menu_btn.custom_minimum_size = Vector2(0, 44)
	open_menu_btn.add_theme_font_size_override("font_size", 12)
	response_actions.add_child(open_menu_btn)
	var notebook_btn := _button("Đọc sổ ghi chép", _show_notebook)
	notebook_btn.custom_minimum_size = Vector2(0, 44)
	notebook_btn.add_theme_font_size_override("font_size", 12)
	response_actions.add_child(notebook_btn)

func _show_recipe_selection() -> void:
	_show_recipe_selection_overlay(false)

func _refresh_recipe_selection_overlay(selecting_menu: bool) -> void:
	if recipe_selection_summary_label != null:
		if selecting_menu:
			recipe_selection_summary_label.text = "Đã chọn: %s món" % selected_menu.size()
		else:
			recipe_selection_summary_label.text = "Đọc ghi chú rồi chọn món phù hợp."
	var selected_recipe := _recipe(recipe_book_selected_id)
	if selected_recipe.is_empty() and not _available_recipes().is_empty():
		selected_recipe = _available_recipes()[0]
	if recipe_selection_title_label != null:
		recipe_selection_title_label.text = str(selected_recipe.get("name", "Món"))
	if recipe_selection_desc_label != null:
		recipe_selection_desc_label.text = str(selected_recipe.get("description", ""))
	_refresh_recipe_selection_detail(selected_recipe)

func _refresh_recipe_selection_detail(selected_recipe: Dictionary) -> void:
	if recipe_selection_detail_root == null:
		return
	for child in recipe_selection_detail_root.get_children():
		child.queue_free()
	if selected_recipe.is_empty():
		recipe_selection_detail_root.add_child(_stage_label("Chưa có món nào được chọn.", Color("#3a2418"), 13))
		return
	var preview_row := HBoxContainer.new()
	preview_row.add_theme_constant_override("separation", 10)
	preview_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	recipe_selection_detail_root.add_child(preview_row)
	var preview_icon := _asset_texture_rect(_recipe_ui_icon_path(selected_recipe), Vector2(40, 40), Rect2(0, 0, 16, 16), true)
	preview_icon.custom_minimum_size = Vector2(40, 40)
	preview_row.add_child(preview_icon)
	var preview_box := VBoxContainer.new()
	preview_box.add_theme_constant_override("separation", 5)
	preview_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	preview_row.add_child(preview_box)
	preview_box.add_child(_stage_label("Nguyên liệu: %s" % ", ".join(selected_recipe.get("ingredients", [])), Color("#3a2418"), 13))
	preview_box.add_child(_stage_label("Hương vị: %s" % ", ".join(selected_recipe.get("flavor_tags", [])), Color("#7a4d31"), 12))
	preview_box.add_child(_stage_label("Cảm xúc: %s" % ", ".join(selected_recipe.get("emotion_tags", [])), Color("#7a4d31"), 12))
	recipe_selection_detail_root.add_child(_stage_label("Ấm %s · Tỉnh %s · Dịu %s" % [
		int(selected_recipe.get("warmth_level", 0)),
		int(selected_recipe.get("caffeine_level", 0)),
		int(selected_recipe.get("comfort_level", 0))
	], Color("#3a2418"), 13))

func _cookable_recipes() -> Array:
	if not selected_menu.is_empty():
		var out: Array = []
		for recipe_id in selected_menu:
			var recipe := _recipe(recipe_id)
			if not recipe.is_empty():
				out.append(recipe)
		if not out.is_empty():
			return out
	return _available_recipes()

func _show_cooking_panel(recipe_id: String) -> void:
	if not selected_menu.is_empty() and not selected_menu.has(recipe_id):
		recipe_id = selected_menu[0]
	var recipe := _recipe(recipe_id)
	_clear()
	_set_game_layout_mode("dialogue")
	_setup_top_bar(true)
	_render_cafe_scene("cook", str(current_visit.get("customer_id", "")), recipe_id)
	_play_cup_chime()
	var cook := _make_art_panel("", Vector2(0, 260), Vector4(26, 12, 26, 12))
	var body := _book_content_box(cook, 8)
	body.add_child(_decor_icon_row([_recipe_ui_icon_path(recipe), UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH], Color("#8f6a45")))
	var columns := _panel_two_column_body(body, 1.12, 0.88, 8)
	var left := columns["left"] as VBoxContainer
	var right := columns["right"] as VBoxContainer
	var right_scroll := ScrollContainer.new()
	right_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_scroll.follow_focus = false
	right.add_child(right_scroll)
	var right_body := VBoxContainer.new()
	right_body.add_theme_constant_override("separation", 6)
	right_body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_scroll.add_child(right_body)

	left.add_child(_stage_label("Chuẩn bị món", Color("#f7eddc"), 15))
	left.add_child(_stage_label("Món đang làm: %s" % recipe.get("name", "Món nóng"), Color("#f2e6ce"), 11))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(row)
	row.add_child(_recipe_ui_icon(recipe, Vector2(40, 40)))
	var preview := VBoxContainer.new()
	preview.add_theme_constant_override("separation", 6)
	preview.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(preview)
	preview.add_child(_stage_label(str(recipe.get("description", "")), Color("#fff6e6"), 11))
	preview.add_child(_stage_label("Chọn cảm giác món muốn gửi vào đêm nay.", Color("#f2e6ce"), 10))

	right_body.add_child(_stage_label("Hương vị / cảm xúc", Color("#f7eddc"), 13))
	_add_chip_row_to(right_body, recipe.get("flavor_tags", []) + recipe.get("emotion_tags", []), true)
	right_body.add_child(_stage_label("Tóm tắt", Color("#f7eddc"), 10))
	right_body.add_child(_stage_label("Một món tốt là món có nhịp vừa với đêm, không nhất thiết phải mạnh nhất.", Color("#f2e6ce"), 10))
	var actions := _panel_button_grid(2, 8)
	right_body.add_child(actions)
	var serve_btn := _button("Mời khách", func(): _serve_recipe(recipe_id))
	serve_btn.custom_minimum_size = Vector2(0, 32)
	serve_btn.add_theme_font_size_override("font_size", 12)
	actions.add_child(serve_btn)
	var redo_btn := _button("Làm lại", _return_to_recipe_selection)
	redo_btn.custom_minimum_size = Vector2(0, 32)
	redo_btn.add_theme_font_size_override("font_size", 12)
	actions.add_child(redo_btn)
	var note_btn := _button("Ghi chú", _show_notebook)
	note_btn.custom_minimum_size = Vector2(0, 32)
	note_btn.add_theme_font_size_override("font_size", 12)
	actions.add_child(note_btn)

func _return_to_recipe_selection() -> void:
	_clear()
	_set_game_layout_mode("book")
	_setup_top_bar(true)
	_render_cafe_scene("dialogue", str(current_visit.get("customer_id", "")))
	_show_recipe_selection_overlay(false)

func _serve_recipe(recipe_id: String) -> void:
	var result := _reaction_result(recipe_id)
	var recipe := _recipe(recipe_id)
	_clear()
	_set_game_layout_mode("dialogue")
	_setup_top_bar(true)
	var customer := _customer(current_visit["customer_id"])
	_render_cafe_scene("serve", str(current_visit["customer_id"]), recipe_id, result)
	_play_cup_chime()
	var panel := _make_art_panel("", Vector2(0, 220), Vector4(30, 16, 30, 16))
	var panel_body := _book_content_box(panel, 8)
	panel_body.add_child(_decor_icon_row([_recipe_ui_icon_path(recipe), UI_ICON_COFFEE_PATH, UI_ICON_BREAD_PATH], Color("#8f6a45")))
	var columns := _panel_two_column_body(panel_body, 1.1, 0.9, 14)
	var left := columns["left"] as VBoxContainer
	var right := columns["right"] as VBoxContainer

	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	head.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(head)
	head.add_child(_dialogue_avatar(str(current_visit.get("customer_id", ""))))
	var head_text := VBoxContainer.new()
	head_text.add_theme_constant_override("separation", 4)
	head_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	head.add_child(head_text)
	head_text.add_child(_stage_label("%s nhận %s" % [customer["name"], recipe["name"]], Color("#f7eddc"), 18))
	head_text.add_child(_stage_label("Phản ứng: %s" % _reaction_label(result), Color("#f2e6ce"), 11))

	var reaction_card := HBoxContainer.new()
	reaction_card.add_theme_constant_override("separation", 12)
	reaction_card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_child(reaction_card)
	reaction_card.add_child(_recipe_ui_icon(recipe, Vector2(50, 50)))
	var lines_box := VBoxContainer.new()
	lines_box.add_theme_constant_override("separation", 4)
	lines_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	reaction_card.add_child(lines_box)
	for line in current_visit["recipe_reactions"].get(result, current_visit["recipe_reactions"].get("bad", [])):
		lines_box.add_child(_stage_label("“%s”" % str(line), Color("#fff6e6"), 11))

	right.add_child(_stage_label("Sổ ghi chép", Color("#f7eddc"), 14))
	var note_box := VBoxContainer.new()
	note_box.add_theme_constant_override("separation", 4)
	note_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_child(note_box)
	for note in current_visit.get("notes_unlock", []):
		if result in ["good", "memory"]:
			_add_customer_note(current_visit["customer_id"], note)
			note_box.add_child(_stage_label("• %s" % note, Color("#fff6e6"), 10))
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
	var next_action := _panel_button_grid(1, 8)
	right.add_child(next_action)
	var next_btn := _button("Khách tiếp theo", func():
		_advance_to_next_customer()
	)
	next_btn.custom_minimum_size = Vector2(0, 34)
	next_btn.add_theme_font_size_override("font_size", 12)
	next_action.add_child(next_btn)

func _advance_to_next_customer() -> void:
	if customer_transition_in_progress:
		return
	customer_transition_in_progress = true
	await _animate_current_customer_departure()
	customer_transition_in_progress = false
	current_visit_index += 1
	_show_next_customer()

func _animate_current_customer_departure() -> void:
	var departing_customer_id := str(current_visit.get("customer_id", ""))
	if departing_customer_id.strip_edges() == "":
		return
	_clear()
	_set_game_layout_mode("dialogue")
	_setup_top_bar(true)
	_render_cafe_scene("leave", departing_customer_id, "", "", false)
	var departing := walking_customer
	if departing == null or not is_instance_valid(departing):
		return
	var exit_points: Array[Vector2] = [
		Vector2(departing.position.x, 340.0),
		Vector2(departing.position.x, 408.0)
	]
	departing.play_walk("down")
	for target in exit_points:
		var guard := 0
		while is_instance_valid(departing) and departing.position.distance_to(target) > 1.5 and guard < 240:
			departing.play_walk("down")
			departing.position = departing.position.move_toward(target, 2.0)
			departing.position = departing.position.floor()
			departing.z_index = int(departing.position.y)
			guard += 1
			await get_tree().process_frame
		if not is_instance_valid(departing):
			break
	if is_instance_valid(departing):
		await get_tree().create_timer(0.15).timeout
		departing.queue_free()
	walking_customer = null
	walking_customer_state = "idle"
	walking_path.clear()
	walking_target_index = 0
	walking_seat_foot = Vector2.ZERO

func _show_closing() -> void:
	_clear()
	_set_game_layout_mode("normal")
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
	var spread := _open_book_overlay("")
	var left := _book_page()
	spread.add_child(left)
	var left_body := _book_page_body(left)
	left_body.add_child(_decor_icon_row([UI_ICON_PLATE_PATH, UI_ICON_CAKE_PATH, UI_ICON_TEA_PATH], Color("#8f6a45")))
	left_body.add_child(_stage_label("Sổ ghi chép", Color("#3a2418"), 22))
	left_body.add_child(_stage_label("Những điều quán học cách nhớ.", Color("#6b4728"), 14))

	var tabs := HFlowContainer.new()
	tabs.add_theme_constant_override("h_separation", 7)
	tabs.add_theme_constant_override("v_separation", 7)
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_body.add_child(tabs)
	for tab in ["Khách quen", "Công thức", "Kỷ vật", "Những đêm mưa", "Ghi chú quán"]:
		var tab_name := str(tab)
		var tab_button := _button(tab_name, func():
			notebook_active_tab = tab_name
			_show_notebook()
		)
		tab_button.custom_minimum_size = Vector2(0, 34)
		tab_button.add_theme_font_size_override("font_size", 12)
		tab_button.add_theme_stylebox_override("normal", _button_style(Color("#d7a64b") if tab_name == notebook_active_tab else Color("#ead7ad")))
		tab_button.add_theme_color_override("font_color", Color("#3a2418"))
		tabs.add_child(tab_button)

	var left_notes := _book_scroll(left_body)
	match notebook_active_tab:
		"Khách quen":
			for customer_id in data["customers"].keys():
				var customer: Dictionary = data["customers"][customer_id]
				var notes: Array = state["customer_notes"].get(customer_id, [])
				var latest := str(notes.back()) if not notes.is_empty() else "Chưa có ghi chú. Có lẽ chỉ là chưa đủ đêm."
				left_notes.add_child(_stage_label("%s · độ quen %s" % [str(customer["name"]), int(state.get("trust", {}).get(customer_id, 0))], Color("#3a2418"), 16))
				left_notes.add_child(_stage_label(latest, Color("#6b4728"), 15))
		"Công thức":
			for recipe in data["recipes"]:
				if state["unlocked_recipes"].has(recipe["id"]):
					left_notes.add_child(_recipe_note_row(recipe))
		"Kỷ vật":
			if state["keepsakes"].is_empty():
				left_notes.add_child(_stage_label("Chưa có gì ngoài vài vệt nước mưa trước cửa.", Color("#3a2418"), 14))
			else:
				for item in state["keepsakes"]:
					left_notes.add_child(_stage_label("• %s" % str(item), Color("#3a2418"), 15))
		"Những đêm mưa":
			var nights_seen := clampi(int(state.get("current_night", 1)), 1, data.get("nights", []).size())
			for i in range(nights_seen):
				var night: Dictionary = data["nights"][i]
				left_notes.add_child(_stage_label(str(night.get("date_label", "Một đêm mưa")), Color("#3a2418"), 16))
				left_notes.add_child(_stage_label(str(night.get("closing_reflection", night.get("weather", ""))), Color("#6b4728"), 15))
		_:
			left_notes.add_child(_stage_label("Quán nhỏ không ghi điểm số. Quán chỉ giữ lại thói quen: ai thích ít ngọt, ai cần ăn chậm, ai thường nói mình ổn quá nhanh.", Color("#3a2418"), 15))
			for line in state.get("last_summary", []):
				left_notes.add_child(_stage_label("• %s" % str(line), Color("#6b4728"), 15))

	var right := _book_page()
	spread.add_child(right)
	var right_body := _book_page_body(right)
	right_body.add_child(_decor_icon_row([UI_ICON_BREAD_PATH, UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH], Color("#8f6a45")))
	right_body.add_child(_stage_label("Trang đang mở", Color("#3a2418"), 19))
	right_body.add_child(_stage_label(notebook_active_tab, Color("#7a4d31"), 15))
	var detail := _book_scroll(right_body)
	match notebook_active_tab:
		"Khách quen":
			detail.add_child(_stage_label("Khách không phải hồ sơ để hoàn thành. Họ là người đã từng ngồi xuống dưới ánh đèn này.", Color("#3a2418"), 15))
			for customer_id in data["customers"].keys():
				var customer: Dictionary = data["customers"][customer_id]
				detail.add_child(_stage_label("• %s: %s" % [str(customer["name"]), str(customer.get("short_description", ""))], Color("#6b4728"), 14))
		"Công thức":
			detail.add_child(_stage_label("Món đúng lúc không nhất thiết là món đắt nhất hay mạnh nhất. Đúng lúc nghĩa là khách nhận ra mình được lắng nghe.", Color("#3a2418"), 15))
		"Kỷ vật":
			detail.add_child(_stage_label("Mỗi vật nhỏ làm quán bớt giống một căn phòng trống.", Color("#3a2418"), 15))
		"Những đêm mưa":
			detail.add_child(_stage_label("Mưa không đêm nào giống đêm nào. Người ghé quán cũng vậy.", Color("#3a2418"), 15))
		_:
			detail.add_child(_stage_label("Ngày mai nhớ kiểm tra nồi cháo, lau lại mép quầy, và để một ly nước ấm sẵn cho người không biết gọi gì.", Color("#3a2418"), 15))
	right_body.add_child(_button("Quay lại trò chuyện", _close_book_overlay))

func _show_recipe_book() -> void:
	_show_recipe_selection_overlay(false)

func _return_to_current_flow() -> void:
	if current_visit.is_empty():
		_show_prep()
	else:
		_show_next_customer()

func _show_demo_ending() -> void:
	state["demo_completed"] = true
	_save_game()
	_clear()
	_set_game_layout_mode("normal")
	_setup_top_bar(false)
	_render_cafe_scene("ending")
	_add_heading("Trời gần sáng")
	for line in data.get("demo_ending", []):
		_add_paragraph(line)
	content.add_child(_button("Xem sổ ghi chép lần cuối", _show_notebook))
	content.add_child(_button("Về menu chính", _show_main_menu))

func _save_game() -> void:
	state["save_version"] = SAVE_VERSION
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
		_migrate_loaded_state()
		if state.get("demo_completed", false):
			_show_demo_ending()
		else:
			_show_prep()

func _migrate_loaded_state() -> void:
	state["save_version"] = SAVE_VERSION
	for key in ["unlocked_recipes", "keepsakes", "completed_visits", "last_summary"]:
		if not state.has(key) or typeof(state[key]) != TYPE_ARRAY:
			state[key] = []
	for key in ["customer_notes", "trust"]:
		if not state.has(key) or typeof(state[key]) != TYPE_DICTIONARY:
			state[key] = {}
	if not state.has("seat_positions") or typeof(state["seat_positions"]) != TYPE_DICTIONARY:
		state["seat_positions"] = {}
	if not state.has("decor") or typeof(state["decor"]) != TYPE_DICTIONARY:
		state["decor"] = {
			"background_path": SCENE_BACKDROP_PATH,
			"chef_id": "player",
			"props": []
		}
	var decor: Dictionary = state["decor"]
	if not decor.has("background_path"):
		decor["background_path"] = SCENE_BACKDROP_PATH
	if not decor.has("chef_id"):
		decor["chef_id"] = "player"
	if not decor.has("props") or typeof(decor["props"]) != TYPE_ARRAY:
		decor["props"] = []
	state["decor"] = decor
	if not state.has("current_night"):
		state["current_night"] = 1
	state["current_night"] = clampi(int(state.get("current_night", 1)), 1, max(1, data.get("nights", []).size() + 1))
	if not state.has("demo_completed"):
		state["demo_completed"] = false
	for recipe in data.get("recipes", []):
		if recipe.get("initial", false) and not state["unlocked_recipes"].has(recipe["id"]):
			state["unlocked_recipes"].append(recipe["id"])

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

func _decor_state() -> Dictionary:
	if not state.has("decor") or typeof(state["decor"]) != TYPE_DICTIONARY:
		state["decor"] = {
			"background_path": SCENE_BACKDROP_PATH,
			"chef_id": "player",
			"props": []
		}
	return state["decor"]

func _decorate_background_options() -> Array[Dictionary]:
	return [
		{"id": "full", "title": "Đêm gốc", "path": SCENE_BACKDROP_PATH},
		{"id": "hd", "title": "Đêm rộng", "path": SCENE_BACKDROP_HD_PATH},
	]

func _decorate_chef_options() -> Array[String]:
	var ids: Array[String] = []
	for key in character_data.keys():
		var cfg: Dictionary = character_data[key]
		if str(cfg.get("idle_sheet", "")).find("characters_free/16x16") != -1:
			ids.append(str(key))
	ids.sort()
	return ids

func _decorative_asset_paths() -> Array[String]:
	var out: Array[String] = []
	for path in _collect_png_asset_paths():
		var lowered := path.to_lower()
		if lowered.find("characters_free") != -1:
			continue
		if lowered.find("spriteframes") != -1:
			continue
		if lowered.find("backgrounds") != -1:
			continue
		if lowered.find("generated/ui/icons") != -1:
			continue
		out.append(path)
	return out

func _is_animated_decor_asset(path: String) -> bool:
	var lowered := path.to_lower()
	return lowered.find("animated_") != -1 or lowered.find("/animated_objects/") != -1 or lowered.find("spritesheets") != -1

func _current_decor_background_path() -> String:
	var decor := _decor_state()
	return str(decor.get("background_path", SCENE_BACKDROP_PATH))

func _current_decor_chef_id() -> String:
	var decor := _decor_state()
	return str(decor.get("chef_id", "player"))

func _current_decor_props() -> Array:
	var decor := _decor_state()
	if not decor.has("props") or typeof(decor["props"]) != TYPE_ARRAY:
		decor["props"] = []
		state["decor"] = decor
	return decor["props"]

func _set_decor_background(path: String) -> void:
	var decor := _decor_state()
	decor["background_path"] = path
	state["decor"] = decor
	_save_game()
	_refresh_current_scene()

func _set_decor_chef(chef_id: String) -> void:
	var decor := _decor_state()
	decor["chef_id"] = chef_id
	state["decor"] = decor
	_save_game()
	_refresh_current_scene()

func _set_decor_prop(path: String) -> void:
	decorate_selected_prop = path

func _place_decor_prop_at(path: String, pos: Vector2) -> void:
	if path.strip_edges() == "":
		return
	var props: Array = _current_decor_props()
	props.append({
		"path": path,
		"position": [int(pos.x), int(pos.y)],
		"animated": _is_animated_decor_asset(path)
	})
	var decor := _decor_state()
	decor["props"] = props
	state["decor"] = decor
	_save_game()
	_refresh_current_scene()

func _render_decor_props() -> void:
	for entry in _current_decor_props():
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var path := str(entry.get("path", ""))
		if path.strip_edges() == "":
			continue
		var raw_pos = entry.get("position", [0, 0])
		var pos := Vector2.ZERO
		if raw_pos is Array and raw_pos.size() >= 2:
			pos = Vector2(float(raw_pos[0]), float(raw_pos[1]))
		if bool(entry.get("animated", false)):
			_add_animated_prop(path, pos, 0, Vector2i(16, 16), 2.0, 4.0, Color("#ffe8c2"))
		else:
			_add_scene_sprite(path, pos, Vector2(32, 32), Color("#ffe8c2"))

func _default_customer_scene_position(customer_id: String) -> Vector2:
	match customer_id:
		"ban_hoa":
			return Vector2(172, 266)
		"bao_ve":
			return Vector2(996, 290)
		"sinh_vien":
			return Vector2(372, 318)
		_:
			return Vector2(380, 188)

func current_visit_id() -> String:
	return str(current_visit.get("customer_id", ""))

func _toggle_seat_place_mode() -> void:
	if decorate_mode:
		decorate_tool = "seat" if decorate_tool != "seat" else ""
		_refresh_current_scene()

func _toggle_decorate_tool(tool_name: String) -> void:
	if decorate_tool == tool_name:
		decorate_tool = ""
	else:
		decorate_tool = tool_name
	_refresh_current_scene()

func _set_customer_seat_position(customer_id: String, pos: Vector2) -> void:
	if customer_id.strip_edges() == "":
		return
	if not state.has("seat_positions") or typeof(state["seat_positions"]) != TYPE_DICTIONARY:
		state["seat_positions"] = {}
	var seats: Dictionary = state["seat_positions"]
	seats[customer_id] = [int(pos.x), int(pos.y)]
	state["seat_positions"] = seats
	_save_game()

func _customer_seat_position(customer_id: String, fallback_pos: Vector2) -> Vector2:
	if customer_id.strip_edges() == "":
		return fallback_pos
	if state.has("seat_positions") and typeof(state["seat_positions"]) == TYPE_DICTIONARY:
		var seats: Dictionary = state["seat_positions"]
		if seats.has(customer_id):
			var raw = seats[customer_id]
			if raw is Array and raw.size() >= 2:
				var candidate := Vector2(float(raw[0]), float(raw[1]))
				return candidate if _is_valid_customer_seat_position(candidate) else fallback_pos
			if raw is Dictionary:
				var candidate := Vector2(float(raw.get("x", fallback_pos.x)), float(raw.get("y", fallback_pos.y)))
				return candidate if _is_valid_customer_seat_position(candidate) else fallback_pos
	return fallback_pos

func _is_valid_customer_seat_position(pos: Vector2) -> bool:
	return pos.x >= 48.0 and pos.x <= SCENE_WIDTH - 48.0 and pos.y >= 72.0 and pos.y <= SCENE_HEIGHT - 16.0

func _on_scene_layer_gui_input(event: InputEvent) -> void:
	if not decorate_mode:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos := scene_layer.get_local_mouse_position()
		if decorate_tool == "seat":
			var customer_id := current_visit_id()
			if customer_id.strip_edges() == "":
				customer_id = current_scene_customer_id
			if customer_id.strip_edges() == "":
				return
			_set_customer_seat_position(customer_id, local_pos)
			_refresh_current_scene()
		elif decorate_tool == "prop":
			if decorate_selected_prop.strip_edges() == "":
				return
			_place_decor_prop_at(decorate_selected_prop, local_pos)
		_refresh_current_scene()

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

func _render_cafe_scene(mode := "idle", customer_id := "", recipe_id := "", result := "", animate_entry := false) -> void:
	if scene_layer == null:
		return
	current_scene_mode = mode
	current_scene_customer_id = customer_id
	current_scene_recipe_id = recipe_id
	current_scene_result = result
	current_scene_animate_entry = animate_entry
	for child in scene_layer.get_children():
		child.queue_free()
	rain_lines.clear()
	steam_lines.clear()
	lamp_glows.clear()
	walking_customer = null
	walking_customer_state = "idle"
	walking_path.clear()
	walking_target_index = 0
	walking_seat_foot = Vector2.ZERO
	var theme := _scene_theme_for_mode(mode)

	_add_scene_backdrop(theme, _current_decor_background_path())
	_add_warm_light(Vector2(210, 96), Vector2(240, 146), float(theme.get("light1", 0.14)))
	_add_warm_light(Vector2(590, 96), Vector2(290, 156), float(theme.get("light2", 0.17)))
	_add_warm_light(Vector2(930, 110), Vector2(220, 138), float(theme.get("light3", 0.11)))
	_add_scene_label("22:00 - 04:00", Vector2(1006, 82), Vector2(180, 24), Color("#d6b98a"), 13)

	var player := _add_character_sprite(_current_decor_chef_id(), Vector2(560, 130), "idle_down", Color("#fff3dc"), true)
	player.z_index = 146

	var active_customer := customer_id
	if active_customer != "" and animate_entry:
		_add_customer_walk_in_scene(active_customer, _walk_in_customer_target_foot())
	elif active_customer != "":
		if mode == "leave":
			_add_customer_leave_scene(active_customer, _walk_in_customer_target_foot())
		else:
			_add_customer_in_scene(active_customer, _walk_in_customer_target_foot(), true, false)

	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(176, 312), 0, Vector2i(16, 16), 2.0, 5.0, Color("#ffe8c2"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png", Vector2(560, 134), 0, Vector2i(16, 32), 2.4, 4.0, Color("#ffe8c2"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cuckoo_clock.png", Vector2(1156, 68), 0, Vector2i(16, 32), 2.0, 5.5, Color("#ffe8c2"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_pan_with_omelette.png", Vector2(710, 164), 0, Vector2i(32, 32), 1.8, 4.0, Color("#ffe8c2"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_toaster.png", Vector2(832, 122), 0, Vector2i(16, 16), 2.2, 5.5, Color("#ffe8c2"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cat.png", Vector2(610, 336), 12, Vector2i(48, 16), 3.0, 4.0, Color("#ffe8c2"))
	_render_decor_props()
	_add_steam(Vector2(438, 156))
	_add_steam(Vector2(742, 156))
	_build_rain()

func _refresh_current_scene() -> void:
	if current_scene_mode == "idle" and current_scene_customer_id == "" and current_scene_recipe_id == "" and current_scene_result == "":
		return
	_render_cafe_scene(current_scene_mode, current_scene_customer_id, current_scene_recipe_id, current_scene_result, current_scene_animate_entry)

func _add_scene_backdrop(theme: Dictionary, backdrop_path := SCENE_BACKDROP_PATH) -> void:
	if backdrop_path.strip_edges() == "":
		backdrop_path = SCENE_BACKDROP_PATH
	var backdrop := _ui_file_texture(backdrop_path, Vector2(SCENE_WIDTH, SCENE_HEIGHT), TextureRect.STRETCH_KEEP_ASPECT_CENTERED)
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backdrop.modulate = theme.get("back_tint", Color(1, 1, 1, 0.98))
	scene_layer.add_child(backdrop)
	var wash := ColorRect.new()
	wash.color = theme.get("wash", Color(1, 1, 1, 0.04))
	wash.set_anchors_preset(Control.PRESET_FULL_RECT)
	wash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene_layer.add_child(wash)
	_add_scene_side_decor(theme)

func _add_scene_side_decor(theme: Dictionary) -> void:
	var left_bar := PanelContainer.new()
	left_bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	left_bar.position = Vector2(14, 14)
	left_bar.custom_minimum_size = Vector2(304, 88)
	left_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	left_bar.clip_contents = true
	left_bar.z_as_relative = false
	left_bar.z_index = 3001
	left_bar.add_theme_stylebox_override("panel", _panel_style(Color(0.16, 0.10, 0.06, 0.82), Color("#6b4728"), 8))
	if scene_hud_root != null:
		scene_hud_root.add_child(left_bar)
	else:
		scene_layer.add_child(left_bar)

	var left_margin := MarginContainer.new()
	left_margin.add_theme_constant_override("margin_left", 10)
	left_margin.add_theme_constant_override("margin_right", 10)
	left_margin.add_theme_constant_override("margin_top", 8)
	left_margin.add_theme_constant_override("margin_bottom", 8)
	left_bar.add_child(left_margin)
	var left_box := HBoxContainer.new()
	left_box.add_theme_constant_override("separation", 10)
	left_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_margin.add_child(left_box)
	var left_col := VBoxContainer.new()
	left_col.add_theme_constant_override("separation", 2)
	left_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_box.add_child(left_col)
	left_col.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BOWL_PATH], Color("#c9a56a")))
	left_col.add_child(_stage_label("Đêm %s" % int(state.get("current_night", 1)), Color("#ffdca2"), 11))
	left_col.add_child(_stage_label("Mưa hẻm", Color("#f1d8a0"), 10))

	var left_text := VBoxContainer.new()
	left_text.add_theme_constant_override("separation", 2)
	left_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_box.add_child(left_text)
	left_text.add_child(_stage_label("%s" % _scene_title_for_mode(current_scene_mode), Color("#f1d8a0"), 11))
	left_text.add_child(_stage_label("Đèn vàng · quầy gỗ", Color("#c7d7d1"), 9))

	var right_bar := PanelContainer.new()
	right_bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	right_bar.position = Vector2(SCENE_WIDTH - 92, 0)
	right_bar.custom_minimum_size = Vector2(92, SCENE_HEIGHT)
	right_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	right_bar.z_as_relative = false
	right_bar.z_index = 3001
	right_bar.add_theme_stylebox_override("panel", _panel_style(Color(0.16, 0.10, 0.06, 0.82), Color("#6b4728"), 8))
	if scene_hud_root != null:
		scene_hud_root.add_child(right_bar)
	else:
		scene_layer.add_child(right_bar)

	var right_margin := MarginContainer.new()
	right_margin.add_theme_constant_override("margin_left", 10)
	right_margin.add_theme_constant_override("margin_right", 10)
	right_margin.add_theme_constant_override("margin_top", 12)
	right_margin.add_theme_constant_override("margin_bottom", 12)
	right_bar.add_child(right_margin)
	var right_box := VBoxContainer.new()
	right_box.add_theme_constant_override("separation", 8)
	right_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_margin.add_child(right_box)
	right_box.add_child(_decor_icon_row([UI_ICON_CAKE_PATH, UI_ICON_BREAD_PATH, UI_ICON_PLATE_PATH], Color("#c9a56a")))
	right_box.add_child(_stage_label("Đêm %s" % int(state.get("current_night", 1)), Color("#ffdca2"), 13))
	right_box.add_child(_stage_label(str(night_weather_from_theme(theme)), Color("#f1d8a0"), 11))
	right_box.add_child(_stage_label("22:00 - 04:00", Color("#9d8464"), 10))
	right_box.add_child(_stage_label("Khung quán", Color("#c7d7d1"), 9))

func night_weather_from_theme(theme: Dictionary) -> String:
	if theme.get("wash", Color.WHITE).a > 0.05:
		return "Mưa ngoài hẻm"
	return "Trời yên"

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
	var light := PanelContainer.new()
	light.position = pos
	light.size = rect_size
	light.mouse_filter = Control.MOUSE_FILTER_IGNORE
	light.z_index = 6
	light.z_as_relative = false
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.64, 0.24, alpha)
	style.border_color = Color(1.0, 0.64, 0.24, alpha)
	style.set_border_width_all(0)
	style.set_corner_radius_all(int(min(rect_size.x, rect_size.y) * 0.5))
	light.add_theme_stylebox_override("panel", style)
	scene_layer.add_child(light)
	lamp_glows.append(light)

func _customer_mood_theme(customer_id: String) -> String:
	match customer_id:
		"ban_hoa", "bao_ve", "van_phong":
			return "sad"
		"sinh_vien", "tai_xe", "dev":
			return "anxious"
		"cap_doi", "y_ta":
			return "bright"
		_:
			return "soft"

func _add_mood_effect(customer_id: String, foot_position: Vector2, strong := false) -> void:
	if scene_layer == null:
		return
	var theme := _customer_mood_theme(customer_id)
	var anchor := foot_position - Vector2(24, 74)
	var base_alpha := 0.12 if strong else 0.08
	match theme:
		"sad":
			for i in 3:
				var cloud := ColorRect.new()
				cloud.color = Color(0.62, 0.70, 0.82, base_alpha + float(i) * 0.02)
				cloud.position = anchor + Vector2(i * 14, 6 + (i % 2) * 3)
				cloud.size = Vector2(20 - i * 2, 12)
				cloud.z_index = int(foot_position.y) - 26
				cloud.mouse_filter = Control.MOUSE_FILTER_IGNORE
				scene_layer.add_child(cloud)
			for i in 4:
				var rain := ColorRect.new()
				rain.color = Color(0.72, 0.82, 0.92, 0.18)
				rain.position = anchor + Vector2(6 + i * 8, 18 + (i % 2) * 4)
				rain.size = Vector2(1, 10 + (i % 2) * 3)
				rain.rotation = deg_to_rad(-12)
				rain.z_index = int(foot_position.y) - 25
				rain.mouse_filter = Control.MOUSE_FILTER_IGNORE
				scene_layer.add_child(rain)
		"anxious":
			for i in 3:
				var spark := ColorRect.new()
				spark.color = Color(0.74, 0.86, 0.94, base_alpha + 0.03)
				spark.position = anchor + Vector2(8 + i * 14, 8 + (i % 2) * 8)
				spark.size = Vector2(3, 3)
				spark.z_index = int(foot_position.y) - 24
				spark.mouse_filter = Control.MOUSE_FILTER_IGNORE
				scene_layer.add_child(spark)
		"bright":
			var glow := ColorRect.new()
			glow.color = Color(1.0, 0.78, 0.28, base_alpha + 0.06)
			glow.position = anchor + Vector2(0, 2)
			glow.size = Vector2(48, 28)
			glow.z_index = int(foot_position.y) - 27
			glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
			scene_layer.add_child(glow)
			for i in 4:
				var ray := ColorRect.new()
				ray.color = Color(1.0, 0.78, 0.28, 0.12)
				ray.position = anchor + Vector2(20 + i * 4, -2 + (i % 2) * 6)
				ray.size = Vector2(1, 10)
				ray.z_index = int(foot_position.y) - 26
				ray.mouse_filter = Control.MOUSE_FILTER_IGNORE
				scene_layer.add_child(ray)
		_:
			var halo := ColorRect.new()
			halo.color = Color(0.92, 0.80, 0.50, base_alpha)
			halo.position = anchor + Vector2(4, 4)
			halo.size = Vector2(34, 20)
			halo.z_index = int(foot_position.y) - 26
			halo.mouse_filter = Control.MOUSE_FILTER_IGNORE
			scene_layer.add_child(halo)

func _add_menu_board() -> void:
	var board := PanelContainer.new()
	board.position = Vector2(382, 22)
	board.size = Vector2(270, 74)
	board.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png", Vector2(550, 186), 6, Vector2i(16, 16), 3.0, 4.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_pan_with_omelette.png", Vector2(720, 170), 16, Vector2i(16, 16), 3.0, 5.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_kitchen_sink_1.png", Vector2(804, 186), 6, Vector2i(16, 16), 3.0, 3.0, Color("#fff0d0"))
	_add_animated_prop(AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(436, 186), 3, Vector2i(16, 16), 3.0, 5.0, Color("#ffdca2"))
	_add_scene_rect(Vector2(894, 142), Vector2(38, 52), Color("#24412b"))
	_add_scene_rect(Vector2(906, 118), Vector2(14, 26), Color("#4c7a47"))
	_add_scene_rect(Vector2(930, 130), Vector2(14, 18), Color("#5c8a52"))
	_add_scene_label("quầy pha", Vector2(584, 210), Vector2(120, 22), Color("#9d8464"), 13)

func _add_counter_front_overlay() -> void:
	_add_scene_rect(Vector2(284, 238), Vector2(712, 18), Color("#2b1b12"), 260)
	_add_scene_rect(Vector2(304, 238), Vector2(672, 6), Color("#8f6a45"), 261)
	_add_scene_rect(Vector2(304, 252), Vector2(672, 4), Color("#1b1009"), 261)

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
	_add_scene_rect(Vector2(158, 292), Vector2(76, 8), Color("#6b4728"), 324)
	_add_scene_rect(Vector2(1024, 292), Vector2(76, 8), Color("#6b4728"), 324)
	_add_scene_rect(Vector2(374, 346), Vector2(78, 8), Color("#6b4728"), 370)
	for pos in [Vector2(590, 274), Vector2(652, 274), Vector2(714, 274)]:
		_add_scene_rect(pos + Vector2(0, 12), Vector2(34, 8), Color("#1b1009"), 310)

func _add_customer_in_scene(customer_id: String, pos: Vector2, active := false, apply_preset_offset := true) -> CharacterSpriteController:
	if active:
		_add_warm_light(pos - Vector2(18, 18), Vector2(104, 104), 0.16)
		_add_scene_label("...", pos + Vector2(-4, -44), Vector2(48, 20), Color("#f1d8a0"), 15)
	var customer := _add_character_sprite(customer_id, pos, "idle_up", Color("#ffffff") if active else Color("#d5c2a6"), apply_preset_offset)
	customer.force_idle_up()
	_add_mood_effect(customer_id, customer.position, active)
	customer.z_index = int(customer.position.y)
	return customer

func _add_customer_at_counter(customer_id: String, active := false, apply_preset_offset := true) -> CharacterSpriteController:
	var seat_foot := _counter_customer_seat_foot()
	if active:
		_add_warm_light(seat_foot - Vector2(18, 30), Vector2(104, 104), 0.16)
		_add_scene_label("...", seat_foot + Vector2(-4, -44), Vector2(48, 20), Color("#f1d8a0"), 15)
	var customer := _add_character_sprite(customer_id, seat_foot, "idle_up", Color("#ffffff") if active else Color("#d5c2a6"), apply_preset_offset)
	customer.force_idle_up()
	_add_mood_effect(customer_id, customer.position, active)
	customer.z_index = int(customer.position.y)
	return customer

func _add_customer_walk_in_scene(customer_id: String, seat_pos: Vector2) -> void:
	_add_warm_light(seat_pos - Vector2(18, 18), Vector2(104, 104), 0.16)
	_add_scene_label("...", seat_pos + Vector2(-4, -44), Vector2(48, 20), Color("#f1d8a0"), 15)
	var spawn := Vector2(seat_pos.x, 408.0)
	var entry := Vector2(seat_pos.x, 340.0)
	var seat_foot := seat_pos
	walking_customer = _add_character_sprite(customer_id, spawn, "walk_up", Color("#ffffff"), false)
	walking_customer.play_walk("up")
	walking_customer_state = "walking_to_seat"
	walking_path = [entry, seat_foot]
	walking_target_index = 0
	walking_seat_foot = seat_foot
	_add_mood_effect(customer_id, seat_foot, true)

func _add_customer_leave_scene(customer_id: String, seat_pos: Vector2) -> void:
	_add_warm_light(seat_pos - Vector2(18, 18), Vector2(104, 104), 0.12)
	_add_scene_label("...", seat_pos + Vector2(-4, -44), Vector2(48, 20), Color("#f1d8a0"), 15)
	walking_customer = _add_customer_in_scene(customer_id, seat_pos, true, false)
	walking_customer_state = "leaving"
	walking_path.clear()
	walking_target_index = 0
	walking_seat_foot = seat_pos
	walking_customer.play_walk("down")

func _update_customer_walk(delta: float) -> void:
	if walking_customer == null or walking_path.is_empty() or walking_customer_state == "counter_idle" or walking_customer_state == "leaving":
		return
	if walking_target_index >= walking_path.size():
		if walking_customer_state == "leaving":
			_finish_customer_departure()
		else:
			_seat_walking_customer()
		return
	var target: Vector2 = walking_path[walking_target_index]
	var to_target: Vector2 = target - walking_customer.position
	if to_target.length() <= 2.0:
		walking_customer.position = target.floor()
		walking_customer.z_index = int(walking_customer.position.y)
		walking_target_index += 1
		if walking_target_index >= walking_path.size():
			_seat_walking_customer()
		return
	var direction := "up"
	if absf(to_target.x) > absf(to_target.y):
		direction = "right" if to_target.x > 0.0 else "left"
	else:
		direction = "down" if to_target.y > 0.0 else "up"
	walking_customer.play_walk(direction)
	walking_customer.position += to_target.normalized() * 82.0 * delta
	walking_customer.position = walking_customer.position.floor()
	walking_customer.z_index = int(walking_customer.position.y)

func _seat_walking_customer() -> void:
	if walking_customer == null:
		return
	walking_customer_state = "counter_idle"
	walking_customer.velocity = Vector2.ZERO
	walking_customer.position = walking_seat_foot.floor()
	walking_customer.force_idle_up()
	walking_customer.z_index = int(walking_customer.position.y)

func _finish_customer_departure() -> void:
	if walking_customer != null and is_instance_valid(walking_customer):
		walking_customer.queue_free()
	walking_customer = null
	walking_customer_state = "idle"
	walking_path.clear()
	walking_target_index = 0
	walking_seat_foot = Vector2.ZERO

func _counter_customer_seat_foot() -> Vector2:
	return Vector2(404, 164)

func _walk_in_customer_target_foot() -> Vector2:
	return _counter_customer_seat_foot() + CHARACTER_SCENE_OFFSET

func _seat_foot_for_customer(customer_id: String, fallback_pos: Vector2) -> Vector2:
	match customer_id:
		"ban_hoa":
			return Vector2(238, 292)
		"bao_ve":
			return Vector2(1002, 332)
		"sinh_vien":
			return Vector2(398, 346)
		"tai_xe":
			return _counter_customer_seat_foot()
		_:
			return fallback_pos

func _add_steam(origin: Vector2) -> void:
	for i in 3:
		var steam := ColorRect.new()
		steam.color = Color(0.86, 0.9, 0.86, 0.28 - i * 0.05)
		steam.position = origin + Vector2(i * 9, -i * 8)
		steam.size = Vector2(4, 20)
		steam.rotation = deg_to_rad(-8 + i * 7)
		steam.z_index = 318
		scene_layer.add_child(steam)
		steam_lines.append(steam)

func _add_scene_status(mode: String, customer_id: String, recipe_id: String, result: String) -> void:
	var pill := PanelContainer.new()
	pill.position = Vector2(32, 112)
	pill.size = Vector2(248, 70)
	pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
		"decorate":
			return "Trang trí quán"
		"ending":
			return "Trời gần sáng"
		_:
			return "Góc quán lúc nửa đêm"

func _scene_theme_for_mode(mode: String) -> Dictionary:
	var phase := int(current_night_index) % 5
	match phase:
		0:
			return {
				"back_tint": Color(1.00, 0.98, 0.94, 1.0),
				"wash": Color(0.82, 0.88, 1.0, 0.025),
				"light1": 0.12,
				"light2": 0.16,
				"light3": 0.10,
			}
		1:
			return {
				"back_tint": Color(0.98, 1.00, 1.00, 1.0),
				"wash": Color(1.0, 0.90, 0.70, 0.035),
				"light1": 0.16,
				"light2": 0.19,
				"light3": 0.12,
			}
		2:
			return {
				"back_tint": Color(0.96, 0.97, 1.00, 1.0),
				"wash": Color(1.0, 0.78, 0.58, 0.045),
				"light1": 0.18,
				"light2": 0.22,
				"light3": 0.15,
			}
		3:
			return {
				"back_tint": Color(0.90, 0.95, 1.00, 1.0),
				"wash": Color(0.72, 0.82, 1.0, 0.05),
				"light1": 0.19,
				"light2": 0.24,
				"light3": 0.15,
			}
		_:
			return {
				"back_tint": Color(1.00, 0.96, 0.90, 1.0),
				"wash": Color(0.55, 0.68, 0.88, 0.06),
				"light1": 0.21,
				"light2": 0.27,
				"light3": 0.18,
			}

func _add_scene_rect(pos: Vector2, rect_size: Vector2, color: Color, z := 0) -> ColorRect:
	var rect := ColorRect.new()
	rect.color = color
	rect.position = pos
	rect.size = rect_size
	rect.z_index = z
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	scene_layer.add_child(rect)
	return rect

func _add_scene_sprite(path: String, pos: Vector2, sprite_size: Vector2, tint := Color.WHITE) -> TextureRect:
	var sprite := TextureRect.new()
	sprite.texture = _atlas_texture(path, Rect2(0, 0, AssetCatalog.TILE_SIZE, AssetCatalog.TILE_SIZE))
	sprite.position = pos + _sprite_preset_offset(path)
	sprite.size = sprite_size
	sprite.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.modulate = tint
	sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	sprite.set_meta("asset_path", path)
	scene_layer.add_child(sprite)
	return sprite

func _add_animated_prop(path: String, foot_position: Vector2, frame_count := -1, frame_size := Vector2i(16, 16), pixel_scale := 3.0, speed := 4.0, tint := Color.WHITE, start_frame := 0) -> AnimatedSprite2D:
	var texture := AssetCatalog.load_texture(path)
	var animation_name := "loop"
	var animation_loop := true
	var uses_saved_preset := false
	var preset: Dictionary = sprite_slice_presets.get(path, {})
	if not preset.is_empty():
		uses_saved_preset = true
		frame_size = Vector2i(
			max(1, int(preset.get("frame_width", frame_size.x))),
			max(1, int(preset.get("frame_height", frame_size.y)))
		)
		start_frame = max(0, int(preset.get("start_frame", start_frame)))
		frame_count = int(preset.get("slice_count", frame_count))
		speed = max(1.0, float(preset.get("fps", speed)))
		animation_name = str(preset.get("animation_name", animation_name)).strip_edges()
		if animation_name == "":
			animation_name = "loop"
		animation_loop = bool(preset.get("loop", true))
	var prop := AnimatedSprite2D.new()
	var frames := SpriteFrames.new()
	frames.add_animation(animation_name)
	frames.set_animation_loop(animation_name, animation_loop)
	frames.set_animation_speed(animation_name, speed)
	var columns: int = max(1, int(texture.get_width() / frame_size.x))
	var rows: int = max(1, int(texture.get_height() / frame_size.y))
	var total_frames: int = columns * rows
	var safe_start_frame: int = clampi(start_frame, 0, max(0, total_frames - 1))
	var available_frames: int = max(1, total_frames - safe_start_frame)
	var frames_to_add: int
	if frame_count <= 0 and rows > 1:
		frames_to_add = min(columns, available_frames)
		if not uses_saved_preset:
			push_warning("Animated prop uses first row only because no frame_count was set: %s" % path)
	elif frame_count <= 0:
		frames_to_add = available_frames
	else:
		frames_to_add = clampi(frame_count, 1, available_frames)
	if texture.get_width() % frame_size.x != 0 or texture.get_height() % frame_size.y != 0:
		push_error("Invalid animated prop grid: %s is %sx%s, frame %sx%s" % [
			path,
			texture.get_width(),
			texture.get_height(),
			frame_size.x,
			frame_size.y
		])
	for offset_index in range(frames_to_add):
		var frame_index := safe_start_frame + offset_index
		var column := frame_index % columns
		var row := int(frame_index / columns)
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(column * frame_size.x, row * frame_size.y, frame_size.x, frame_size.y)
		frames.add_frame(animation_name, atlas)
	prop.sprite_frames = frames
	prop.animation = animation_name
	prop.centered = true
	prop.offset = Vector2(0, -float(frame_size.y) * 0.5)
	prop.position = (foot_position + _sprite_preset_offset(path)).floor()
	prop.scale = Vector2(pixel_scale * 0.5, pixel_scale * 0.5)
	prop.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	prop.modulate = tint
	prop.z_index = int(foot_position.y)
	prop.set_meta("asset_path", path)
	scene_layer.add_child(prop)
	prop.play()
	return prop

func _add_character_sprite(character_id: String, foot_position: Vector2, animation_name := "", tint := Color.WHITE, apply_preset_offset := true) -> CharacterSpriteController:
	var controller := CharacterSpriteController.new()
	var sprite_offset := _character_sprite_offset(character_id, animation_name) if apply_preset_offset else Vector2.ZERO
	controller.position = (foot_position + sprite_offset).floor()
	controller.z_index = int(foot_position.y)
	controller.modulate = tint
	controller.set_meta("asset_path", str(_character_config(character_id).get("idle_sheet", "")))
	controller.set_meta("asset_path_alt", str(_character_config(character_id).get("full_sheet", "")))
	scene_layer.add_child(controller)
	controller.configure(character_id, _character_config(character_id), animation_name)
	return controller

func _character_sprite_offset(character_id: String, animation_name := "") -> Vector2:
	var config: Dictionary = _character_config(character_id)
	var chosen_path := str(config.get("idle_sheet", ""))
	if animation_name.begins_with("walk") or animation_name.begins_with("run"):
		chosen_path = str(config.get("run_sheet", ""))
		if chosen_path == "":
			var char_name := str(config.get("character_name", character_id))
			chosen_path = "res://assets/limezu/characters_free/16x16/%s_run_16x16.png" % char_name
		if chosen_path == "":
			chosen_path = str(config.get("full_sheet", chosen_path))
	elif animation_name == "seated_idle":
		chosen_path = str(config.get("sit_sheet", chosen_path))
	if chosen_path == "":
		chosen_path = str(config.get("full_sheet", ""))
	if chosen_path == "":
		chosen_path = str(config.get("sit_sheet", ""))
	return _sprite_preset_offset(chosen_path)

func _sprite_preset_offset(path: String) -> Vector2:
	var preset: Dictionary = sprite_slice_presets.get(path, {})
	return Vector2(
		float(preset.get("offset_x", 0)) + float(preset.get("original_offset_x", 0)),
		float(preset.get("offset_y", 0)) + float(preset.get("original_offset_y", 0))
	)

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
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
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
	var applied_font_size: int = max(12, int(round(12 * ui_scale)))
	label.add_theme_font_size_override("font_size", applied_font_size)
	label.add_theme_color_override("font_color", color)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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

func _recipe_ui_icon(recipe: Dictionary, size := Vector2(48, 48)) -> TextureRect:
	return _asset_texture_rect(_recipe_ui_icon_path(recipe), size, Rect2(0, 0, 16, 16), true)

func _recipe_ui_icon_path(recipe: Dictionary) -> String:
	var id := str(recipe.get("id", ""))
	var name := str(recipe.get("name", "")).to_lower()
	match id:
		"ca_phe_den_nong", "ca_phe_sua", "bac_xiu_am", "cacao_nong":
			return UI_ICON_HOT_COCOA_PATH if name.contains("cacao") or name.contains("cocoa") else UI_ICON_COFFEE_PATH
		"tra_gung_mat_ong", "tra_hoa_cuc_mat_ong", "tra_sen_am", "tra_dao_it_ngot", "tra_sen_dem_mua", "chanh_muoi_am", "sua_nong_mat_ong", "sua_dau_nanh_nong":
			if name.contains("chanh") or name.contains("mat ong") or name.contains("mật ong"):
				return UI_ICON_HONEY_LEMON_TEA_PATH
			if name.contains("hoa cuc") or name.contains("sen") or name.contains("gung"):
				return UI_ICON_HERBAL_TEA_PATH
			return UI_ICON_TEA_PATH if not name.contains("sua") else UI_ICON_MILK_PATH
		"chao_trang_trung", "sup_nong_rau_thom", "chao_hanh_tieu_that_nhe":
			return UI_ICON_PORRIDGE_PATH
		"mi_trung", "mi_bo_it_cay":
			return UI_ICON_NOODLES_PATH
		"banh_mi_chao_nho":
			return UI_ICON_SANDWICH_PATH
		"com_rang_trung":
			return UI_ICON_FRIED_RICE_PATH
		"banh_mi_trung":
			return UI_ICON_OMELETTE_RICE_PATH
		"sup_thit_bam", "sup_nam":
			return UI_ICON_PORRIDGE_PATH
		"banh_ngot", "banh_cream", "banh_tra_xanh", "banh_tra_sua":
			return UI_ICON_CAKE_PATH
		_:
			if name.contains("toast") or name.contains("bánh mì"):
				return UI_ICON_TOAST_PATH if name.contains("toast") else UI_ICON_BREAD_PATH
			if name.contains("trứng"):
				return UI_ICON_EGG_PATH if not name.contains("cơm") else UI_ICON_OMELETTE_RICE_PATH
			if name.contains("sữa"):
				return UI_ICON_MILK_PATH
			if name.contains("noodle") or name.contains("mì"):
				return UI_ICON_NOODLES_PATH
			if name.contains("rice") or name.contains("cơm"):
				return UI_ICON_FRIED_RICE_PATH
			if name.contains("trà"):
				return UI_ICON_TEAPOT_PATH
			return UI_ICON_CAKE_PATH

func _recipe_button_text(recipe: Dictionary) -> String:
	var warmth := int(recipe.get("warmth_level", 0))
	var caffeine := int(recipe.get("caffeine_level", 0))
	var comfort := int(recipe.get("comfort_level", 0))
	return "Ấm %s · Tỉnh %s · Dịu %s" % [warmth, caffeine, comfort]

func _recipe_is_selected(recipe_id: String) -> bool:
	return selected_menu.has(recipe_id)

func _decor_icon_row(icons: Array[String], tint := Color(1, 1, 1, 1)) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for icon_path in icons:
		var icon := _asset_texture_rect(icon_path, Vector2(20, 20), Rect2(0, 0, 16, 16), true)
		icon.custom_minimum_size = Vector2(20, 20)
		icon.modulate = tint
		row.add_child(icon)
	return row

func _book_card_button(parent: Control, title_text: String, meta_text: String, icon_path: String, min_size: Vector2, on_pressed: Callable, accent := Color("#ead7ad"), border := Color("#8f6a45"), title_color := Color("#3a2418"), meta_color := Color("#7a4d31"), disabled := false) -> Button:
	var card := PanelContainer.new()
	card.custom_minimum_size = min_size
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.clip_contents = true
	card.add_theme_stylebox_override("panel", _panel_style(accent, border, 6))
	parent.add_child(card)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.clip_contents = true
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	card.add_child(margin)

	var row := HBoxContainer.new()
	row.set_anchors_preset(Control.PRESET_FULL_RECT)
	row.add_theme_constant_override("separation", 10)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.size_flags_vertical = Control.SIZE_EXPAND_FILL
	row.clip_contents = true
	margin.add_child(row)

	var icon := _asset_texture_rect(icon_path, Vector2(36, 36), Rect2(0, 0, 16, 16), true)
	icon.custom_minimum_size = Vector2(40, 40)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	row.add_child(icon)

	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 4)
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	text_box.clip_contents = true
	row.add_child(text_box)

	var title := _stage_label(title_text, title_color, 16)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_child(title)

	var meta := _stage_label(meta_text, meta_color, 14)
	meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	meta.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.add_child(meta)

	var hit := Button.new()
	hit.set_anchors_preset(Control.PRESET_FULL_RECT)
	hit.focus_mode = Control.FOCUS_NONE
	hit.flat = true
	hit.disabled = disabled
	hit.mouse_filter = Control.MOUSE_FILTER_STOP
	hit.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	hit.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	hit.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	hit.add_theme_stylebox_override("disabled", StyleBoxEmpty.new())
	hit.text = ""
	hit.modulate = Color(1, 1, 1, 0.001)
	hit.pressed.connect(on_pressed)
	hit.set_meta("title_label", title)
	hit.set_meta("meta_label", meta)
	hit.set_meta("recipe_title", title)
	hit.set_meta("recipe_meta", meta)
	card.add_child(hit)
	return hit

func _add_recipe_menu_book(recipes: Array, selecting_menu: bool) -> void:
	var spread := _make_art_book(Vector2(0, 430))
	var left_box := VBoxContainer.new()
	left_box.add_theme_constant_override("separation", 8)
	left_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spread.add_child(left_box)
	left_box.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BOWL_PATH], Color("#8f6a45")))
	left_box.add_child(_stage_label("Quyển menu đêm", Color("#3a2418"), 21))
	left_box.add_child(_stage_label("Chọn món bằng icon và ghi chú hương vị.", Color("#6b4728"), 14))

	var scroll := ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_box.add_child(scroll)

	var list := VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(list)

	for recipe in recipes:
		var recipe_id: String = str(recipe["id"])
		var current_recipe_id := recipe_id
		var button := _recipe_menu_button(recipe, selecting_menu)
		if selecting_menu:
			button.pressed.connect(func(): _toggle_menu_recipe(current_recipe_id))
			menu_recipe_buttons[current_recipe_id] = button
			_update_menu_recipe_button(current_recipe_id)
		else:
			button.pressed.connect(func(): _show_cooking_panel(current_recipe_id))
		list.add_child(button)

	var right_box := VBoxContainer.new()
	right_box.add_theme_constant_override("separation", 8)
	right_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	spread.add_child(right_box)
	right_box.add_child(_stage_label("Ghi chú quán", Color("#d7a64b"), 16))
	if selecting_menu:
		right_box.add_child(_decor_icon_row([UI_ICON_CAKE_PATH, UI_ICON_PLATE_PATH, UI_ICON_BREAD_PATH], Color("#8f6a45")))
		right_box.add_child(_stage_label("Ghi chú chuẩn bị", Color("#3a2418"), 16))
		right_box.add_child(_stage_label("Chọn tối đa 5 món. Đây là nhịp mở quán, không phải bảng điểm.", Color("#6b4728"), 12))
		right_box.add_child(_stage_label("Đã chọn", Color("#7a4d31"), 14))
		menu_selection_label = _stage_label("", Color("#3a2418"), 12)
		right_box.add_child(menu_selection_label)
		_refresh_menu_selection_label()
	else:
		right_box.add_child(_decor_icon_row([UI_ICON_COFFEE_PATH, UI_ICON_TEA_PATH, UI_ICON_BREAD_PATH], Color("#8f6a45")))
		right_box.add_child(_stage_label("Chọn món đúng lúc", Color("#3a2418"), 16))
		var customer_id := str(current_visit.get("customer_id", ""))
		if customer_id != "":
			var customer := _customer(customer_id)
			right_box.add_child(_stage_label(str(customer.get("name", "Khách ghé quán")), Color("#7a4d31"), 14))
			right_box.add_child(_stage_label(str(current_visit.get("mood", "")), Color("#6b4728"), 12))
		recipe_selection_summary_label = _stage_label("Đọc lời khách, thời tiết, và ghi chú cũ. Món hợp không nhất thiết là món mạnh nhất.", Color("#3a2418"), 12)
		right_box.add_child(recipe_selection_summary_label)
		right_box.add_child(_stage_label("Ấm: đêm mưa. Tỉnh: còn việc phải làm. Dịu: đã quá mệt.", Color("#3a2418"), 12))

func _menu_page_panel(min_size: Vector2) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = min_size
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_stylebox_override("panel", _panel_style(Color("#ead7ad"), Color("#8f6a45"), 5))
	return panel

func _menu_page_box(page: PanelContainer) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	page.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(box)
	return box

func _recipe_menu_button(recipe: Dictionary, selecting_menu: bool) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 68)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.clip_contents = true
	button.add_theme_color_override("font_color", Color("#3a2418"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#f1d8a0") if selecting_menu else Color("#ead7ad")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#ffd58a")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#d7a64b")))
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.clip_contents = true
	button.add_child(row)
	var icon := _recipe_ui_icon(recipe, Vector2(28, 28))
	icon.custom_minimum_size = Vector2(28, 28)
	row.add_child(icon)
	var text_box := VBoxContainer.new()
	text_box.add_theme_constant_override("separation", 3)
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	text_box.clip_contents = true
	row.add_child(text_box)
	var title := _stage_label(str(recipe.get("name", "Món")), Color("#3a2418"), 13)
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(title)
	var meta := _stage_label(_recipe_button_text(recipe), Color("#7a4d31"), 11)
	meta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text_box.add_child(meta)
	button.set_meta("recipe_title", title)
	button.set_meta("recipe_meta", meta)
	return button

func _recipe_note_row(recipe: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	row.add_child(_recipe_ui_icon(recipe, Vector2(28, 28)))
	var label := _stage_label(str(recipe.get("name", "Món")), Color("#3a2418"), 15)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(label)
	return row

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
	var title := button.get_meta("recipe_title") as Label if button.has_meta("recipe_title") else null
	if title == null and button.has_meta("title_label"):
		title = button.get_meta("title_label") as Label
	var meta := button.get_meta("recipe_meta") as Label if button.has_meta("recipe_meta") else null
	if meta == null and button.has_meta("meta_label"):
		meta = button.get_meta("meta_label") as Label
	if title != null:
		title.text = "%s%s" % [prefix, str(recipe.get("name", "Món"))]
	if meta != null:
		meta.text = _recipe_button_text(recipe)
	var card := button.get_parent()
	if card is PanelContainer:
		card.add_theme_stylebox_override("panel", _panel_style(
			Color("#e6b75c") if selected_menu.has(recipe_id) else Color("#ead7ad"),
			Color("#d7a64b") if selected_menu.has(recipe_id) else Color("#8f6a45"),
			6
		))
	if title != null:
		title.add_theme_color_override("font_color", Color("#2b1b12") if selected_menu.has(recipe_id) else Color("#3a2418"))
	if meta != null:
		meta.add_theme_color_override("font_color", Color("#6b4728") if selected_menu.has(recipe_id) else Color("#7a4d31"))
	_refresh_menu_selection_label()

func _refresh_menu_selection_label() -> void:
	if menu_selection_label == null:
		return
	if selected_menu.is_empty():
		menu_selection_label.text = "Chưa chọn món nào. Nếu để trống, quán tự bày 5 món đầu."
		return
	var names: Array[String] = []
	for recipe_id in selected_menu:
		var recipe := _recipe(recipe_id)
		names.append("• %s" % str(recipe.get("name", recipe_id)))
	menu_selection_label.text = "\n".join(names)

func _add_filter_chips(labels: Array, active := false) -> void:
	_add_chip_row_to(content, labels, active)

func _add_chip_row_to(parent: Control, labels: Array, active := false) -> void:
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 8)
	flow.add_theme_constant_override("v_separation", 8)
	flow.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	parent.add_child(flow)
	for label in labels:
		flow.add_child(_chip(str(label).capitalize(), active))

func _chip(text: String, active := false) -> PanelContainer:
	var chip := PanelContainer.new()
	chip.clip_contents = true
	chip.add_theme_stylebox_override("panel", _panel_style(Color("#4a2d18") if active else Color("#2a1a12"), Color("#d7a64b") if active else Color("#6b4728"), 4))
	chip.custom_minimum_size = Vector2(max(104, int(text.length() * 9) + 30), 34)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 7)
	margin.add_theme_constant_override("margin_bottom", 7)
	chip.add_child(margin)
	var label := _stage_label(text, Color("#ffe3ad") if active else Color("#9d8464"), 12)
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	margin.add_child(label)
	return chip

func _add_slider_row(label_text: String, value: float) -> HBoxContainer:
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
	return row

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
	box.add_child(_stage_label(title, Color("#3a2418"), 20))
	box.add_child(_stage_label(subtitle, Color("#6b4728"), 15))
	for line in lines:
		box.add_child(_stage_label("• %s" % str(line), Color("#2b1b12"), 15))

func _button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 30)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", int(round(12 * ui_scale)))
	button.add_theme_color_override("font_color", Color("#ffe8c2"))
	button.add_theme_stylebox_override("normal", _button_style(Color("#3a2b24")))
	button.add_theme_stylebox_override("hover", _button_style(Color("#5a3d2d")))
	button.add_theme_stylebox_override("pressed", _button_style(Color("#7a4d31")))
	button.add_theme_stylebox_override("disabled", _button_style(Color("#201711")))
	button.add_theme_color_override("font_disabled_color", Color("#6f5a40"))
	button.pressed.connect(_play_ui_click)
	button.pressed.connect(callable)
	return button

func _compact_lines(lines: Array, limit: int) -> Array[String]:
	var out: Array[String] = []
	for i in range(min(limit, lines.size())):
		out.append(str(lines[i]))
	return out

func _dialogue_avatar(customer_id: String) -> PanelContainer:
	var frame := PanelContainer.new()
	frame.custom_minimum_size = Vector2(56, 56)
	frame.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	frame.clip_contents = true
	frame.add_theme_stylebox_override("panel", _panel_style(Color("#f5e2bc"), Color("#8f6a45"), 12))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 5)
	margin.add_theme_constant_override("margin_right", 5)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	margin.clip_contents = true
	frame.add_child(margin)
	var portrait := _character_portrait(customer_id)
	portrait.custom_minimum_size = Vector2(46, 46)
	portrait.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	portrait.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin.add_child(portrait)
	return frame

func _character_portrait(customer_id: String) -> TextureRect:
	var config := _character_config(customer_id)
	var idle_sheet := str(config.get("idle_sheet", ""))
	var frame_width: int = max(1, int(config.get("idle_frame_width", config.get("frame_width", 16))))
	var frame_height: int = max(1, int(config.get("idle_frame_height", config.get("frame_height", 16))))
	var region := Rect2(frame_width * 3, 0, frame_width, frame_height)
	var portrait := _asset_texture_rect(idle_sheet, Vector2(46, 46), region, true)
	portrait.expand_mode = TextureRect.EXPAND_FIT_HEIGHT_PROPORTIONAL
	portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	portrait.modulate = Color("#fff4db")
	return portrait

func _setup_audio() -> void:
	if ambience_player == null:
		ambience_player = AudioStreamPlayer.new()
		add_child(ambience_player)
	if rain_audio_player == null:
		rain_audio_player = AudioStreamPlayer.new()
		add_child(rain_audio_player)
	if cricket_audio_player == null:
		cricket_audio_player = AudioStreamPlayer.new()
		add_child(cricket_audio_player)
	if traffic_audio_player == null:
		traffic_audio_player = AudioStreamPlayer.new()
		add_child(traffic_audio_player)
	if dog_audio_player == null:
		dog_audio_player = AudioStreamPlayer.new()
		add_child(dog_audio_player)
	if radio_audio_player == null:
		radio_audio_player = AudioStreamPlayer.new()
		add_child(radio_audio_player)
	if bgm_player == null:
		bgm_player = AudioStreamPlayer.new()
		add_child(bgm_player)
	if not bgm_player.finished.is_connected(_on_bgm_finished):
		bgm_player.finished.connect(_on_bgm_finished)
	if ui_click_player == null:
		ui_click_player = AudioStreamPlayer.new()
		add_child(ui_click_player)
	if cup_sfx_player == null:
		cup_sfx_player = AudioStreamPlayer.new()
		add_child(cup_sfx_player)
	if dog_bark_timer == null:
		dog_bark_timer = Timer.new()
		dog_bark_timer.one_shot = true
		dog_bark_timer.wait_time = 22.0
		dog_bark_timer.autostart = false
		dog_bark_timer.timeout.connect(_on_dog_bark_timer_timeout)
		add_child(dog_bark_timer)
	ambience_player.volume_db = -20.0
	rain_audio_player.volume_db = -24.0
	cricket_audio_player.volume_db = -28.0
	traffic_audio_player.volume_db = -30.0
	dog_audio_player.volume_db = -20.0
	radio_audio_player.volume_db = -24.0
	bgm_player.volume_db = -10.0
	bgm_player.autoplay = true
	ui_click_player.volume_db = -12.0
	cup_sfx_player.volume_db = -10.0
	ambience_player.stream = _make_loop_wav(0.0, 0.04, 0.012, 0.0)
	rain_audio_player.stream = _load_audio_loop(RAIN_AMBIENCE_PATHS, _make_rain_wav())
	cricket_audio_player.stream = _load_audio_loop(CRICKET_AMBIENCE_PATHS, _make_cricket_wav())
	traffic_audio_player.stream = _load_audio_loop(TRAFFIC_AMBIENCE_PATHS, _make_traffic_wav())
	dog_audio_player.stream = _load_audio_clip(DOG_AMBIENCE_PATHS, _make_dog_wav())
	radio_audio_player.stream = _make_radio_wav()
	bgm_player.stream = _load_bgm_track()
	bgm_player.autoplay = true
	ui_click_player.stream = _make_click_wav()
	cup_sfx_player.stream = _make_chime_wav()

func _start_ambience() -> void:
	if ambience_player != null and not ambience_player.playing:
		ambience_player.play()
	if rain_audio_player != null and not rain_audio_player.playing:
		rain_audio_player.play()
	if cricket_audio_player != null and not cricket_audio_player.playing:
		cricket_audio_player.play()
	if traffic_audio_player != null and not traffic_audio_player.playing:
		traffic_audio_player.play()
	if radio_audio_player != null and not radio_audio_player.playing:
		radio_audio_player.play()
	if bgm_player != null:
		if bgm_player.playing:
			bgm_player.stop()
		if bgm_player.stream == null:
			bgm_player.stream = _load_bgm_track()
		bgm_player.play()
		bgm_player.volume_db = -10.0
	if dog_bark_timer != null and dog_bark_timer.is_stopped():
		dog_bark_timer.wait_time = 24.0 + audio_rng.randf_range(0.0, 26.0)
		dog_bark_timer.start()

func _play_ui_click() -> void:
	if ui_click_player == null or ui_click_player.stream == null:
		return
	ui_click_player.stop()
	ui_click_player.play()

func _play_cup_chime() -> void:
	if cup_sfx_player == null or cup_sfx_player.stream == null:
		return
	cup_sfx_player.stop()
	cup_sfx_player.play()

func _on_dog_bark_timer_timeout() -> void:
	if dog_audio_player == null or dog_audio_player.stream == null:
		return
	if audio_rng.randf() < 0.42:
		dog_audio_player.stop()
		dog_audio_player.play()
	if dog_bark_timer != null:
		dog_bark_timer.wait_time = 28.0 + audio_rng.randf_range(0.0, 34.0)
		dog_bark_timer.start()

func _on_bgm_finished() -> void:
	if bgm_player == null:
		return
	bgm_player.stream = _load_bgm_track()
	bgm_player.play()

func _make_loop_wav(freq_a: float, amp_a: float, amp_noise: float, freq_b: float) -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 4.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var wobble := sin(TAU * 0.25 * t) * 0.5 + sin(TAU * 0.17 * t + 0.7) * 0.5
		var hum := sin(TAU * 55.0 * t) * amp_a + sin(TAU * 110.0 * t + 0.25) * amp_a * 0.5
		var noise := (sin(float(i) * 12.9898 + 78.233) * 43758.5453)
		noise = noise - floor(noise)
		noise = (noise * 2.0 - 1.0) * amp_noise * (0.65 + wobble * 0.35)
		var tone := hum + noise + sin(TAU * max(1.0, freq_b) * t) * 0.0
		var sample := int(clampf(tone, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _make_click_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 0.10
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var env := pow(1.0 - clampf(t / duration, 0.0, 1.0), 2.2)
		var tone := sin(TAU * (820.0 - 220.0 * t) * t) * 0.18 * env
		var sample := int(clampf(tone, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = bytes
	return stream

func _make_rain_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 4.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var hiss := (sin(float(i) * 91.7) * 0.5 + sin(float(i) * 47.3 + 1.2) * 0.5)
		var pulse := sin(TAU * 1.6 * t) * 0.12
		var sample := int(clampf((hiss * 0.08 + pulse) * 1.0, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _make_cricket_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 4.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var chirp_a := sin(TAU * 4.2 * t + sin(TAU * 0.7 * t) * 0.15) * 0.022
		var chirp_b := sin(TAU * 7.8 * t + 0.8) * 0.011
		var hiss := (sin(float(i) * 71.7 + 2.2) * 0.5 + sin(float(i) * 39.3 + 0.4) * 0.5) * 0.02
		var sample := int(clampf(chirp_a + chirp_b + hiss, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _make_traffic_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 4.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var base := sin(TAU * 55.0 * t) * 0.018
		var tire := sin(TAU * 31.0 * t + sin(TAU * 0.3 * t) * 0.4) * 0.010
		var hiss := (sin(float(i) * 17.3 + 0.8) * 0.5 + sin(float(i) * 11.9 + 2.4) * 0.5) * 0.014
		var sample := int(clampf(base + tire + hiss, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _make_dog_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 0.35
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var env := exp(-t * 8.0)
		var bark := sin(TAU * (150.0 - 55.0 * t) * t) * 0.24
		var growl := sin(TAU * 83.0 * t + 0.2) * 0.08
		var sample := int(clampf((bark + growl) * env, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = bytes
	return stream

func _make_radio_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 4.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var melody := sin(TAU * 220.0 * t) * 0.012 + sin(TAU * 330.0 * t + 0.9) * 0.01
		var hiss_noise := (sin(float(i) * 17.13 + 4.2) * 0.5 + sin(float(i) * 29.77 + 1.7) * 0.5) * 0.02
		var sample := int(clampf(melody + hiss_noise, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _make_cozy_bgm_wav() -> AudioStreamWAV:
	var sample_rate := 44100
	var duration := 12.0
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	var chords := [
		[220.0, 261.63, 329.63],
		[174.61, 220.0, 277.18],
		[196.0, 246.94, 311.13],
		[164.81, 220.0, 261.63]
	]
	var bass := [110.0, 98.0, 130.81, 87.31]
	var melody := [329.63, 392.0, 440.0, 392.0, 349.23, 392.0, 440.0, 493.88]
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var bar := int(floor(t / 3.0)) % 4
		var beat_phase := fmod(t, 0.75) / 0.75
		var chord: Array = chords[bar]
		var lead_note: float = float(melody[int(floor(t * 2.0)) % melody.size()])
		var bass_note: float = float(bass[bar])
		var chord_env: float = 0.78 + 0.22 * (1.0 - abs(beat_phase * 2.0 - 1.0))
		var tone := 0.0
		tone += sin(TAU * bass_note * 0.5 * t) * 0.12
		tone += sin(TAU * chord[0] * t + 0.05) * 0.060 * chord_env
		tone += sin(TAU * chord[1] * t + 0.18) * 0.050 * chord_env
		tone += sin(TAU * chord[2] * t + 0.31) * 0.042 * chord_env
		tone += sin(TAU * lead_note * t + 0.4) * 0.034 * (0.6 + 0.4 * beat_phase)
		tone += sin(TAU * 0.5 * t) * 0.014
		var noise := (sin(float(i) * 13.1 + 0.3) * 0.5 + sin(float(i) * 9.7 + 2.2) * 0.5) * 0.002
		tone += noise
		var sample := int(clampf(tone, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.data = bytes
	return stream

func _load_bgm_track() -> AudioStream:
	var stream := _load_audio_loop(BGM_TRACK_PATHS, _make_cozy_bgm_wav())
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = false
	elif stream is AudioStreamWAV:
		(stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED
	return stream

func _load_audio_loop(paths: Array, fallback: AudioStream) -> AudioStream:
	var candidates := paths.duplicate()
	if candidates.is_empty():
		return fallback
	candidates.shuffle()
	for path in candidates:
		var stream := _load_mp3_stream(path)
		if stream != null:
			return stream
	return fallback

func _load_audio_clip(paths: Array, fallback: AudioStream) -> AudioStream:
	var stream := _load_audio_loop(paths, fallback)
	if stream is AudioStreamMP3:
		(stream as AudioStreamMP3).loop = false
	elif stream is AudioStreamWAV:
		(stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_DISABLED
	return stream

func _load_mp3_stream(path: String, loop := true) -> AudioStream:
	if not FileAccess.file_exists(path):
		return null
	var bytes := FileAccess.get_file_as_bytes(path)
	if bytes.is_empty():
		return null
	var stream := AudioStreamMP3.new()
	stream.data = bytes
	stream.loop = loop
	return stream

func _place_asset_in_scene(path: String) -> void:
	if path.strip_edges() == "":
		return
	var center := Vector2(scene_layer.size.x * 0.5, scene_layer.size.y * 0.46)
	if _is_animated_decor_asset(path):
		_place_decor_prop_at(path, center)
	else:
		state["decor"]["props"].append({
			"path": path,
			"position": [int(center.x), int(center.y)],
			"animated": false
		})
		_save_game()
	_refresh_current_scene()

func _remove_asset_from_scene(path: String) -> void:
	var decor := _decor_state()
	if not decor.has("props") or typeof(decor["props"]) != TYPE_ARRAY:
		return
	var props: Array = decor["props"]
	for i in range(props.size() - 1, -1, -1):
		var entry: Variant = props[i]
		if entry is Dictionary and str(entry.get("path", "")) == path:
			props.remove_at(i)
	decor["props"] = props
	state["decor"] = decor
	_save_game()
	_refresh_current_scene()

func _make_chime_wav() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 0.18
	var total_samples := int(sample_rate * duration)
	var bytes := PackedByteArray()
	bytes.resize(total_samples * 2)
	for i in range(total_samples):
		var t := float(i) / float(sample_rate)
		var env := exp(-t * 14.0)
		var tone := sin(TAU * 1320.0 * t) * 0.16 * env
		tone += sin(TAU * 1760.0 * t + 0.3) * 0.08 * env
		var sample := int(clampf(tone, -1.0, 1.0) * 32767.0)
		bytes[i * 2] = sample & 0xFF
		bytes[i * 2 + 1] = (sample >> 8) & 0xFF
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	stream.mix_rate = sample_rate
	stream.loop_mode = AudioStreamWAV.LOOP_DISABLED
	stream.data = bytes
	return stream

func _button_style(fill: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = Color("#8f6a45")
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 9
	style.content_margin_bottom = 9
	return style

func _add_heading(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#ffd58a"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_subheading(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#f4c27a"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_meta(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#9fb8b4"))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_paragraph(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#f4e6d5"))
	label.add_theme_color_override("font_outline_color", Color("#1b1009"))
	label.add_theme_constant_override("outline_size", 3)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_dialogue(text: String) -> Label:
	var label := Label.new()
	label.text = "“%s”" % text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#fff4df"))
	label.add_theme_color_override("font_outline_color", Color("#1b1009"))
	label.add_theme_constant_override("outline_size", 3)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_note(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("#d3ead9"))
	label.add_theme_color_override("font_outline_color", Color("#1b1009"))
	label.add_theme_constant_override("outline_size", 3)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ui_text_parent.add_child(label)
	return label

func _add_bullet(text: String) -> void:
	_add_paragraph("• %s" % text)
