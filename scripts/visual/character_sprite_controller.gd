class_name CharacterSpriteController
extends AnimatedSprite2D

const IDLE_FRAME_ORDER := {
	"left": 0,
	"up": 1,
	"right": 2,
	"down": 3
}

var character_id := ""
var frame_width := 16
var frame_height := 16
var idle_frame_width := 16
var idle_frame_height := 16
var full_frame_width := 16
var full_frame_height := 16
var run_frame_width := 16
var run_frame_height := 32
var sit_frame_width := 16
var sit_frame_height := 16
var last_direction := "down"
var default_direction := "down"
var state := "idle"
var velocity := Vector2.ZERO
var idle_time := 0.0
var base_offset := Vector2.ZERO
var has_run_sheet := false

func _process(delta: float) -> void:
	if state == "idle" or state == "seated_idle":
		idle_time += delta
		offset = base_offset
	else:
		idle_time = 0.0
		offset = base_offset

func configure(id: String, config: Dictionary, requested_animation := "") -> void:
	character_id = id
	idle_frame_width = int(config.get("idle_frame_width", config.get("frame_width", 16)))
	idle_frame_height = int(config.get("idle_frame_height", config.get("frame_height", 16)))
	full_frame_width = int(config.get("full_frame_width", config.get("frame_width", idle_frame_width)))
	full_frame_height = int(config.get("full_frame_height", config.get("frame_height", idle_frame_height)))
	run_frame_width = int(config.get("run_frame_width", idle_frame_width))
	run_frame_height = int(config.get("run_frame_height", idle_frame_height))
	sit_frame_width = int(config.get("sit_frame_width", config.get("frame_width", idle_frame_width)))
	sit_frame_height = int(config.get("sit_frame_height", config.get("frame_height", idle_frame_height)))
	default_direction = str(config.get("default_direction", "down"))
	frame_width = idle_frame_width
	frame_height = idle_frame_height

	sprite_frames = _create_sprite_frames(config)
	centered = true
	offset = Vector2(0, -float(frame_height) * 0.5)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var pixel_scale := float(config.get("scale", 3.0)) * 0.5
	scale = Vector2(pixel_scale, pixel_scale)

	var animation_name := requested_animation
	if animation_name == "":
		animation_name = str(config.get("default_animation", "idle_down"))
	play_named(animation_name)

func play_named(animation_name: String) -> void:
	if animation_name == "seated_idle":
		play_seated()
		return
	if animation_name == "walk_right":
		state = "walk"
		if has_run_sheet and sprite_frames.has_animation("run_right"):
			flip_h = false
			_play_if_exists("run_right")
		else:
			flip_h = true
			_play_if_exists("walk_left")
		return
	flip_h = false
	state = "walk" if animation_name.begins_with("walk") else "idle"
	_play_if_exists(animation_name)

func set_state(new_state: String) -> void:
	state = new_state
	if new_state == "seated_idle":
		play_seated()
	elif new_state == "walking":
		play_walk(last_direction)
	elif new_state == "idle" or new_state == "talking":
		play_idle(default_direction)

func set_direction(direction: String) -> void:
	last_direction = direction

func play_idle(direction := "down") -> void:
	last_direction = direction
	play_named("idle_%s" % direction)

func play_walk(direction := "left") -> void:
	last_direction = direction
	if has_run_sheet:
		play_run(direction)
		return
	if direction == "right":
		play_named("walk_right")
	elif direction == "left":
		play_named("walk_left")
	elif direction == "up":
		play_named("walk_up")
	elif direction == "down":
		play_named("walk_down")
	else:
		play_named("idle_%s" % direction)

func play_run(direction := "left") -> void:
	last_direction = direction
	if sprite_frames != null and sprite_frames.has_animation("run_%s" % direction):
		play_named("run_%s" % direction)
	else:
		play_walk(direction)

func play_seated() -> void:
	state = "seated_idle"
	last_direction = "down"
	flip_h = false
	_play_if_exists("idle_up")

func force_idle_down() -> void:
	state = "idle"
	last_direction = "down"
	flip_h = false
	_play_if_exists("idle_down")

func force_idle_up() -> void:
	state = "idle"
	last_direction = "up"
	flip_h = false
	_play_if_exists("idle_up")

func set_animation_state(state: String, direction: String) -> void:
	last_direction = direction
	if state == "walk":
		play_walk(direction)
	else:
		play_idle(direction)

func sit_down() -> void:
	play_seated()

func face_down_or_seated() -> void:
	sit_down()

func _play_if_exists(animation_name: String) -> void:
	if sprite_frames == null:
		return
	if not sprite_frames.has_animation(animation_name):
		animation_name = "idle_down"
	_apply_offset_for_animation(animation_name)
	play(animation_name)

func _create_sprite_frames(config: Dictionary) -> SpriteFrames:
	var frames := SpriteFrames.new()
	var idle_texture := _load_texture(str(config.get("idle_sheet", "")))
	if idle_texture != null:
		_add_idle_animations(frames, idle_texture)

	var run_texture := _load_texture(_resolve_run_sheet_path(config))
	if run_texture != null:
		has_run_sheet = true
		_add_run_animations(frames, run_texture, config)

	var full_texture := _load_texture(str(config.get("full_sheet", "")))
	if full_texture != null:
		_add_walk_left(frames, full_texture, config)
		_add_walk_vertical_fallbacks(frames)

	if frames.has_animation("idle_down"):
		frames.add_animation("seated_idle")
		frames.set_animation_loop("seated_idle", true)
		frames.set_animation_speed("seated_idle", 1.0)
		var seated_source := "idle_up" if frames.has_animation("idle_up") else "idle_down"
		frames.add_frame("seated_idle", frames.get_frame_texture(seated_source, 0))
	return frames

func _resolve_run_sheet_path(config: Dictionary) -> String:
	var explicit := str(config.get("run_sheet", ""))
	if explicit != "":
		return explicit
	var name := str(config.get("character_name", "")).strip_edges()
	if name != "":
		return "res://assets/limezu/characters_free/16x16/%s_run_16x16.png" % name
	return ""

func _add_idle_animations(frames: SpriteFrames, texture: Texture2D) -> void:
	_validate_grid(texture, "idle", idle_frame_width, idle_frame_height)
	for direction in IDLE_FRAME_ORDER.keys():
		var animation_name := "idle_%s" % direction
		frames.add_animation(animation_name)
		frames.set_animation_loop(animation_name, true)
		frames.set_animation_speed(animation_name, 1.0)
		frames.add_frame(animation_name, _atlas_frame(texture, int(IDLE_FRAME_ORDER[direction]), 0, idle_frame_width, idle_frame_height))

func _add_walk_left(frames: SpriteFrames, texture: Texture2D, config: Dictionary) -> void:
	_validate_grid(texture, "full", full_frame_width, full_frame_height)
	var row := int(config.get("walk_row", 1))
	var start_col := int(config.get("walk_left_start_col", 12))
	var frame_count := int(config.get("walk_frame_count", 6))
	var columns := int(texture.get_width() / full_frame_width)
	var rows := int(texture.get_height() / full_frame_height)
	if row >= rows or start_col >= columns:
		push_error("Invalid walk strip for %s: row %s / col %s outside %sx%s grid" % [
			character_id,
			row,
			start_col,
			columns,
			rows
		])
		return
	var frames_to_add: int = min(frame_count, columns - start_col)
	frames.add_animation("walk_left")
	frames.set_animation_loop("walk_left", true)
	frames.set_animation_speed("walk_left", 7.0)
	for i in range(frames_to_add):
		frames.add_frame("walk_left", _atlas_frame(texture, start_col + i, row, full_frame_width, full_frame_height))

func _add_run_animations(frames: SpriteFrames, texture: Texture2D, config: Dictionary) -> void:
	_validate_grid(texture, "run", run_frame_width, run_frame_height)
	var frames_per_direction := int(config.get("run_frames_per_direction", 6))
	var direction_order: Array = config.get("run_direction_order", ["right", "up", "left", "down"])
	var columns := int(texture.get_width() / run_frame_width)
	var rows := int(texture.get_height() / run_frame_height)
	if rows < 1 or columns < frames_per_direction:
		push_error("Invalid run strip for %s: %sx%s with %sx%s frames" % [
			character_id,
			texture.get_width(),
			texture.get_height(),
			run_frame_width,
			run_frame_height
		])
		return
	if direction_order.is_empty():
		direction_order = ["right", "up", "left", "down"]
	for dir_index in range(direction_order.size()):
		var direction := str(direction_order[dir_index])
		var animation_name := "run_%s" % direction
		frames.add_animation(animation_name)
		frames.set_animation_loop(animation_name, true)
		frames.set_animation_speed(animation_name, 9.0)
		var start_col := dir_index * frames_per_direction
		if start_col + frames_per_direction > columns:
			start_col = max(0, columns - frames_per_direction)
		for i in range(frames_per_direction):
			frames.add_frame(animation_name, _atlas_frame(texture, start_col + i, 0, run_frame_width, run_frame_height))

func _add_walk_vertical_fallbacks(frames: SpriteFrames) -> void:
	if frames.has_animation("walk_left"):
		var up_frames: Array[Texture2D] = []
		var down_frames: Array[Texture2D] = []
		if frames.has_animation("idle_up"):
			up_frames.append(frames.get_frame_texture("idle_up", 0))
		if frames.has_animation("idle_down"):
			down_frames.append(frames.get_frame_texture("idle_down", 0))
		frames.add_animation("walk_up")
		frames.set_animation_loop("walk_up", true)
		frames.set_animation_speed("walk_up", 7.0)
		frames.add_animation("walk_down")
		frames.set_animation_loop("walk_down", true)
		frames.set_animation_speed("walk_down", 7.0)
		if not up_frames.is_empty():
			for i in range(frames.get_frame_count("walk_left")):
				frames.add_frame("walk_up", up_frames[0])
		else:
			for i in range(frames.get_frame_count("walk_left")):
				frames.add_frame("walk_up", frames.get_frame_texture("walk_left", i))
		if not down_frames.is_empty():
			for i in range(frames.get_frame_count("walk_left")):
				frames.add_frame("walk_down", down_frames[0])
		else:
			for i in range(frames.get_frame_count("walk_left")):
				frames.add_frame("walk_down", frames.get_frame_texture("walk_left", i))

func _add_seated_idle(frames: SpriteFrames, texture: Texture2D) -> void:
	_validate_grid(texture, "sit", sit_frame_width, sit_frame_height)
	frames.add_animation("seated_idle")
	frames.set_animation_loop("seated_idle", true)
	frames.set_animation_speed("seated_idle", 1.8)
	var start_col: int = 18 if texture.get_width() >= 384 else 0
	var frame_count: int = min(6, int(texture.get_width() / sit_frame_width) - start_col)
	for i in range(max(1, frame_count)):
		frames.add_frame("seated_idle", _atlas_frame(texture, start_col + i, 0, sit_frame_width, sit_frame_height))

func _atlas_frame(texture: Texture2D, column: int, row: int, width: int, height: int) -> AtlasTexture:
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = Rect2(column * width, row * height, width, height)
	return atlas

func _load_texture(path: String) -> Texture2D:
	if path == "":
		return null
	if path.ends_with(".png") or path.ends_with(".jpg") or path.ends_with(".jpeg") or path.ends_with(".webp"):
		var real_path := path if path.is_absolute_path() else ProjectSettings.globalize_path(path)
		var image := Image.new()
		if path.ends_with(".png"):
			var bytes := FileAccess.get_file_as_bytes(real_path)
			if not bytes.is_empty() and image.load_png_from_buffer(bytes) == OK:
				return ImageTexture.create_from_image(image)
		else:
			if image.load(real_path) == OK:
				return ImageTexture.create_from_image(image)
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Missing LimeZu character texture: %s" % path)
	return texture

func _apply_offset_for_animation(animation_name: String) -> void:
	if animation_name == "walk_up" or animation_name == "idle_up" or animation_name == "seated_idle":
		var height: int = max(full_frame_height, max(idle_frame_height, sit_frame_height))
		base_offset = Vector2(0, -float(height) * 0.5)
	elif animation_name.begins_with("run"):
		base_offset = Vector2(0, -float(run_frame_height) * 0.5)
	elif animation_name.begins_with("walk"):
		base_offset = Vector2(0, -float(full_frame_height) * 0.5)
	else:
		base_offset = Vector2(0, -float(idle_frame_height) * 0.5)
	offset = base_offset

func _validate_grid(texture: Texture2D, label: String, width: int, height: int) -> void:
	if texture.get_width() % width != 0 or texture.get_height() % height != 0:
		push_error("Invalid %s sheet grid for %s: %sx%s is not divisible by %sx%s" % [
			label,
			character_id,
			texture.get_width(),
			texture.get_height(),
			width,
			height
		])
