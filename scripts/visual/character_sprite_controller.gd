class_name CharacterSpriteController
extends AnimatedSprite2D

const IDLE_FRAME_ORDER := {
	"left": 0,
	"up": 1,
	"down": 2,
	"right": 3
}

var character_id := ""
var frame_width := 16
var frame_height := 16
var idle_frame_width := 16
var idle_frame_height := 16
var full_frame_width := 16
var full_frame_height := 16
var sit_frame_width := 16
var sit_frame_height := 16
var last_direction := "down"
var state := "idle"
var velocity := Vector2.ZERO

func configure(id: String, config: Dictionary, requested_animation := "") -> void:
	character_id = id
	idle_frame_width = int(config.get("idle_frame_width", config.get("frame_width", 16)))
	idle_frame_height = int(config.get("idle_frame_height", config.get("frame_height", 16)))
	full_frame_width = int(config.get("full_frame_width", config.get("frame_width", idle_frame_width)))
	full_frame_height = int(config.get("full_frame_height", config.get("frame_height", idle_frame_height)))
	sit_frame_width = int(config.get("sit_frame_width", config.get("frame_width", idle_frame_width)))
	sit_frame_height = int(config.get("sit_frame_height", config.get("frame_height", idle_frame_height)))
	frame_width = idle_frame_width
	frame_height = idle_frame_height

	sprite_frames = _create_sprite_frames(config)
	centered = true
	offset = Vector2(0, -float(frame_height) * 0.5)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var pixel_scale := float(config.get("scale", 3.0))
	scale = Vector2(pixel_scale, pixel_scale)

	var animation_name := requested_animation
	if animation_name == "":
		animation_name = str(config.get("default_animation", "idle_down"))
	play_named(animation_name)

func play_named(animation_name: String) -> void:
	if animation_name == "walk_right":
		flip_h = true
		state = "walk"
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
		play_idle(last_direction)

func set_direction(direction: String) -> void:
	last_direction = direction

func play_idle(direction := "down") -> void:
	last_direction = direction
	play_named("idle_%s" % direction)

func play_walk(direction := "left") -> void:
	last_direction = direction
	if direction == "right":
		play_named("walk_right")
	elif direction == "left":
		play_named("walk_left")
	else:
		play_named("idle_%s" % direction)

func play_seated() -> void:
	state = "seated_idle"
	last_direction = "down"
	flip_h = false
	_play_if_exists("seated_idle")

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

	var full_texture := _load_texture(str(config.get("full_sheet", "")))
	if full_texture != null:
		_add_walk_left(frames, full_texture, config)

	var sit_texture := _load_texture(str(config.get("sit_sheet", "")))
	if sit_texture != null and bool(config.get("use_seated_pose", false)):
		_add_seated_idle(frames, sit_texture)
	elif frames.has_animation("idle_down"):
		frames.add_animation("seated_idle")
		frames.set_animation_loop("seated_idle", true)
		frames.set_animation_speed("seated_idle", 1.0)
		frames.add_frame("seated_idle", frames.get_frame_texture("idle_down", 0))
	return frames

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
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Missing LimeZu character texture: %s" % path)
	return texture

func _apply_offset_for_animation(animation_name: String) -> void:
	if animation_name.begins_with("walk"):
		offset = Vector2(0, -float(full_frame_height) * 0.5)
	elif animation_name == "seated_idle":
		offset = Vector2(0, -float(sit_frame_height) * 0.5)
	else:
		offset = Vector2(0, -float(idle_frame_height) * 0.5)

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
