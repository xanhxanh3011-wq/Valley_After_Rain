@tool
extends EditorPlugin

const PRESET_PATH := "res://data/sprite_slice_presets.json"

var dock: VBoxContainer
var texture_path_edit: LineEdit
var output_path_edit: LineEdit
var animation_name_edit: LineEdit
var frame_width_spin: SpinBox
var frame_height_spin: SpinBox
var start_frame_spin: SpinBox
var slice_count_spin: SpinBox
var fps_spin: SpinBox
var loop_check: CheckBox
var status_label: Label

func _enter_tree() -> void:
	dock = VBoxContainer.new()
	dock.name = "Sprite Sheet Slicer"
	dock.custom_minimum_size = Vector2(320, 0)
	dock.add_theme_constant_override("separation", 8)

	var title := Label.new()
	title.text = "Sprite Sheet Slicer"
	title.add_theme_font_size_override("font_size", 18)
	dock.add_child(title)

	var hint := Label.new()
	hint.text = "Select a PNG in FileSystem or type res:// path, then enter frame size and slice count."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dock.add_child(hint)

	texture_path_edit = _line_edit("res://assets/limezu/animated_objects/16x16/spritesheets/animated_cat.png")
	dock.add_child(_labeled_control("Texture path", texture_path_edit))

	var selected_button := Button.new()
	selected_button.text = "Use selected FileSystem PNG"
	selected_button.pressed.connect(_use_selected_path)
	dock.add_child(selected_button)

	var preset_buttons := HBoxContainer.new()
	preset_buttons.add_theme_constant_override("separation", 6)
	dock.add_child(preset_buttons)

	var load_preset_button := Button.new()
	load_preset_button.text = "Load preset"
	load_preset_button.pressed.connect(_load_preset_for_current_texture)
	preset_buttons.add_child(load_preset_button)

	var save_preset_button := Button.new()
	save_preset_button.text = "Save preset"
	save_preset_button.pressed.connect(_save_preset_for_current_texture)
	preset_buttons.add_child(save_preset_button)

	output_path_edit = _line_edit("res://assets/spriteframes/animated_cat_48x16_12.tres")
	dock.add_child(_labeled_control("Output .tres path", output_path_edit))

	animation_name_edit = _line_edit("loop")
	dock.add_child(_labeled_control("Animation name", animation_name_edit))

	frame_width_spin = _spin(1, 512, 48)
	dock.add_child(_labeled_control("Frame width", frame_width_spin))

	frame_height_spin = _spin(1, 512, 16)
	dock.add_child(_labeled_control("Frame height", frame_height_spin))

	start_frame_spin = _spin(0, 9999, 0)
	dock.add_child(_labeled_control("Start frame", start_frame_spin))

	slice_count_spin = _spin(0, 9999, 12)
	dock.add_child(_labeled_control("Slice count (0 = auto)", slice_count_spin))

	fps_spin = _spin(1, 60, 4)
	dock.add_child(_labeled_control("FPS", fps_spin))

	loop_check = CheckBox.new()
	loop_check.text = "Loop animation"
	loop_check.button_pressed = true
	dock.add_child(loop_check)

	var generate_button := Button.new()
	generate_button.text = "Create SpriteFrames Resource"
	generate_button.pressed.connect(_create_sprite_frames_resource)
	dock.add_child(generate_button)

	status_label = Label.new()
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	dock.add_child(status_label)

	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)
	_load_preset_for_current_texture(false)

func _exit_tree() -> void:
	if dock != null:
		remove_control_from_docks(dock)
		dock.queue_free()

func _line_edit(default_text: String) -> LineEdit:
	var edit := LineEdit.new()
	edit.text = default_text
	edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return edit

func _spin(min_value: int, max_value: int, default_value: int) -> SpinBox:
	var spin := SpinBox.new()
	spin.min_value = min_value
	spin.max_value = max_value
	spin.step = 1
	spin.value = default_value
	spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return spin

func _labeled_control(label_text: String, control: Control) -> VBoxContainer:
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	var label := Label.new()
	label.text = label_text
	box.add_child(label)
	box.add_child(control)
	return box

func _use_selected_path() -> void:
	var paths := EditorInterface.get_selected_paths()
	if paths.is_empty():
		_set_status("No FileSystem path selected.", true)
		return
	var path := str(paths[0])
	texture_path_edit.text = path
	var base := path.get_file().get_basename()
	output_path_edit.text = "res://assets/spriteframes/%s_%sx%s.tres" % [
		base,
		int(frame_width_spin.value),
		int(frame_height_spin.value)
	]
	_load_preset_for_current_texture(false)
	_set_status("Selected: %s" % path)

func _create_sprite_frames_resource() -> void:
	var texture_path := texture_path_edit.text.strip_edges()
	var output_path := output_path_edit.text.strip_edges()
	var animation_name := animation_name_edit.text.strip_edges()
	if animation_name == "":
		animation_name = "loop"

	var texture := load(texture_path) as Texture2D
	if texture == null:
		_set_status("Cannot load texture: %s" % texture_path, true)
		return

	var frame_width := int(frame_width_spin.value)
	var frame_height := int(frame_height_spin.value)
	if texture.get_width() % frame_width != 0 or texture.get_height() % frame_height != 0:
		_set_status("Texture %sx%s is not divisible by frame %sx%s." % [
			texture.get_width(),
			texture.get_height(),
			frame_width,
			frame_height
		], true)
		return

	var columns := int(texture.get_width() / frame_width)
	var rows := int(texture.get_height() / frame_height)
	var total_frames := columns * rows
	var start_frame := int(start_frame_spin.value)
	if start_frame >= total_frames:
		_set_status("Start frame %s is outside total frames %s." % [start_frame, total_frames], true)
		return

	var requested_count := int(slice_count_spin.value)
	var frame_count := total_frames - start_frame if requested_count <= 0 else requested_count
	frame_count = min(frame_count, total_frames - start_frame)

	var sprite_frames := SpriteFrames.new()
	sprite_frames.add_animation(animation_name)
	sprite_frames.set_animation_loop(animation_name, loop_check.button_pressed)
	sprite_frames.set_animation_speed(animation_name, float(fps_spin.value))

	for offset_index in range(frame_count):
		var frame_index := start_frame + offset_index
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(
			(frame_index % columns) * frame_width,
			int(frame_index / columns) * frame_height,
			frame_width,
			frame_height
		)
		sprite_frames.add_frame(animation_name, atlas)

	var output_dir := output_path.get_base_dir()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_dir))
	var error := ResourceSaver.save(sprite_frames, output_path)
	if error != OK:
		_set_status("Failed to save %s. Error %s." % [output_path, error], true)
		return

	_save_preset_for_current_texture(false)
	EditorInterface.get_resource_filesystem().scan()
	_set_status("Saved %s with %s frames of %sx%s from %s." % [
		output_path,
		frame_count,
		frame_width,
		frame_height,
		texture_path
	])

func _load_preset_for_current_texture(show_status := true) -> void:
	var texture_path := texture_path_edit.text.strip_edges()
	var presets := _read_presets()
	if not presets.has(texture_path):
		if show_status:
			_set_status("No saved preset for: %s" % texture_path, true)
		return

	var preset: Dictionary = presets[texture_path]
	output_path_edit.text = str(preset.get("output_path", output_path_edit.text))
	animation_name_edit.text = str(preset.get("animation_name", "loop"))
	frame_width_spin.value = int(preset.get("frame_width", frame_width_spin.value))
	frame_height_spin.value = int(preset.get("frame_height", frame_height_spin.value))
	start_frame_spin.value = int(preset.get("start_frame", start_frame_spin.value))
	slice_count_spin.value = int(preset.get("slice_count", slice_count_spin.value))
	fps_spin.value = int(preset.get("fps", fps_spin.value))
	loop_check.button_pressed = bool(preset.get("loop", true))
	if show_status:
		_set_status("Loaded preset for: %s" % texture_path)

func _save_preset_for_current_texture(show_status := true) -> void:
	var texture_path := texture_path_edit.text.strip_edges()
	if texture_path == "":
		_set_status("Cannot save preset without a texture path.", true)
		return

	var presets := _read_presets()
	presets[texture_path] = {
		"output_path": output_path_edit.text.strip_edges(),
		"animation_name": animation_name_edit.text.strip_edges(),
		"frame_width": int(frame_width_spin.value),
		"frame_height": int(frame_height_spin.value),
		"start_frame": int(start_frame_spin.value),
		"slice_count": int(slice_count_spin.value),
		"fps": int(fps_spin.value),
		"loop": loop_check.button_pressed
	}
	_write_presets(presets)
	if show_status:
		_set_status("Saved preset for: %s" % texture_path)

func _read_presets() -> Dictionary:
	if not FileAccess.file_exists(PRESET_PATH):
		return {}
	var text := FileAccess.get_file_as_string(PRESET_PATH)
	var parsed = JSON.parse_string(text)
	if typeof(parsed) == TYPE_DICTIONARY:
		return parsed
	return {}

func _write_presets(presets: Dictionary) -> void:
	var dir := PRESET_PATH.get_base_dir()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var file := FileAccess.open(PRESET_PATH, FileAccess.WRITE)
	if file == null:
		_set_status("Cannot write preset file: %s" % PRESET_PATH, true)
		return
	file.store_string(JSON.stringify(presets, "\t"))
	file.close()
	EditorInterface.get_resource_filesystem().scan()

func _set_status(message: String, is_error := false) -> void:
	status_label.text = message
	status_label.add_theme_color_override("font_color", Color("#ff9b8a") if is_error else Color("#b8d7c5"))
