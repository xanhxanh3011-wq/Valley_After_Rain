class_name GifDecorationLoader
extends RefCounted

const AssetCatalog := preload("res://scripts/core/asset_catalog.gd")

const GIF_TO_SPRITESHEET := {
	"animated_cat.gif": {
		"sheet": "animated_cat.png",
		"frame_count": 36,
		"speed": 4.0
	},
	"animated_candle.gif": {
		"sheet": "animated_candle.png",
		"frame_count": 3,
		"speed": 5.0
	},
	"animated_coffee.gif": {
		"sheet": "animated_coffee.png",
		"frame_count": 6,
		"speed": 4.0
	},
	"animated_kitchen_pan_with_omelette_16x16.gif": {
		"sheet": "animated_kitchen_pan_with_omelette.png",
		"frame_count": 16,
		"speed": 5.0
	}
}

static func create_sprite_frames(gif_path: String, frame_size := Vector2i(16, 16), start_frame := 0) -> SpriteFrames:
	var file_name := gif_path.get_file()
	var mapping: Dictionary = GIF_TO_SPRITESHEET.get(file_name, {})
	if mapping.is_empty():
		push_error("No GIF decoration mapping for: %s" % gif_path)
		return SpriteFrames.new()

	var sheet_path := AssetCatalog.LIMEZU_ANIMATED_16_DIR + str(mapping["sheet"])
	var texture := AssetCatalog.load_texture(sheet_path)
	var frames := SpriteFrames.new()
	frames.add_animation("loop")
	frames.set_animation_loop("loop", true)
	frames.set_animation_speed("loop", float(mapping.get("speed", 4.0)))

	var columns: int = max(1, int(texture.get_width() / frame_size.x))
	var rows: int = max(1, int(texture.get_height() / frame_size.y))
	var total_frames := columns * rows
	var safe_start_frame: int = clampi(start_frame, 0, max(0, total_frames - 1))
	var frame_count: int = min(int(mapping.get("frame_count", columns)), total_frames - safe_start_frame)

	for offset_index in range(max(1, frame_count)):
		var frame_index := safe_start_frame + offset_index
		var atlas := AtlasTexture.new()
		atlas.atlas = texture
		atlas.region = Rect2(
			(frame_index % columns) * frame_size.x,
			int(frame_index / columns) * frame_size.y,
			frame_size.x,
			frame_size.y
		)
		frames.add_frame("loop", atlas)

	return frames
