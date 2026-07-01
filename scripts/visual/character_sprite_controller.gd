class_name CharacterSpriteController
extends AnimatedSprite2D

const DEFAULT_ANIMATIONS := {
	"idle_down": [0, 1, 2, 3],
	"walk_down": [4, 5, 6, 7],
	"idle_left": [8, 9, 10, 11],
	"walk_left": [12, 13, 14, 15],
	"idle_right": [16, 17, 18, 19],
	"walk_right": [20, 21, 22, 23],
	"idle_up": [24, 25, 26, 27],
	"walk_up": [28, 29, 30, 31],
	"seated_idle": [32, 33, 34, 35],
	"brew_idle": [36, 37, 38, 39],
	"serve_down": [36, 37, 38, 39]
}

var character_id := ""
var frame_width := 32
var frame_height := 48

func configure(id: String, config: Dictionary, requested_animation := "") -> void:
	character_id = id
	frame_width = int(config.get("frame_width", 32))
	frame_height = int(config.get("frame_height", 48))
	var texture := load(str(config.get("sheet", ""))) as Texture2D
	if texture == null:
		push_error("Missing character sheet for %s" % id)
		return

	sprite_frames = _build_sprite_frames(texture, config)
	centered = true
	offset = Vector2(0, -float(frame_height) * 0.5)
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var pixel_scale := float(config.get("scale", 2.0))
	scale = Vector2(pixel_scale, pixel_scale)

	var animation_name := requested_animation
	if animation_name == "":
		animation_name = str(config.get("default_animation", "idle_down"))
	play_state(animation_name)

func play_state(animation_name: String) -> void:
	if sprite_frames == null:
		return
	if not sprite_frames.has_animation(animation_name):
		animation_name = "idle_down"
	play(animation_name)

func _build_sprite_frames(texture: Texture2D, config: Dictionary) -> SpriteFrames:
	var out := SpriteFrames.new()
	var animations: Dictionary = DEFAULT_ANIMATIONS.duplicate(true)
	for key in config.get("animations", {}).keys():
		animations[key] = config["animations"][key]

	for animation_name in animations.keys():
		out.add_animation(animation_name)
		out.set_animation_loop(animation_name, true)
		out.set_animation_speed(animation_name, _animation_speed(animation_name))
		for frame_index in animations[animation_name]:
			out.add_frame(animation_name, _frame_texture(texture, int(frame_index)))
	return out

func _frame_texture(texture: Texture2D, frame_index: int) -> AtlasTexture:
	var columns: int = max(1, int(texture.get_width() / frame_width))
	var row: int = int(frame_index / columns)
	var region := Rect2(
		float(frame_index % columns) * frame_width,
		float(row) * frame_height,
		frame_width,
		frame_height
	)
	var atlas := AtlasTexture.new()
	atlas.atlas = texture
	atlas.region = region
	return atlas

func _animation_speed(animation_name: String) -> float:
	if animation_name.begins_with("walk"):
		return 7.5
	if animation_name == "seated_idle":
		return 1.8
	return 2.4
