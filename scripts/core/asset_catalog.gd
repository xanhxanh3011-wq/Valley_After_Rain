class_name AssetCatalog

const TILE_SIZE := 16

const LIMEZU_ANIMATED_16_DIR := "res://assets/limezu/animated_objects/16x16/spritesheets/"
const LIMEZU_CHARACTER_16_DIR := "res://assets/limezu/characters_free/16x16/"

static func load_texture(path: String) -> Texture2D:
	if path.ends_with(".png") or path.ends_with(".jpg") or path.ends_with(".jpeg") or path.ends_with(".webp"):
		var image := Image.new()
		var real_path := path if path.is_absolute_path() else ProjectSettings.globalize_path(path)
		if path.ends_with(".png"):
			var bytes := FileAccess.get_file_as_bytes(real_path)
			if not bytes.is_empty() and image.load_png_from_buffer(bytes) == OK:
				return ImageTexture.create_from_image(image)
		else:
			if image.load(real_path) == OK:
				return ImageTexture.create_from_image(image)
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Missing texture: %s" % path)
	return texture

static func get_png_dimensions(path: String) -> Vector2i:
	if not path.ends_with(".png"):
		return Vector2i(-1, -1)
	var real_path := path if path.is_absolute_path() else ProjectSettings.globalize_path(path)
	var bytes := FileAccess.get_file_as_bytes(real_path)
	if bytes.size() < 24:
		return Vector2i(-1, -1)
	# PNG signature must match.
	if bytes[0] != 0x89 or bytes[1] != 0x50 or bytes[2] != 0x4E or bytes[3] != 0x47:
		return Vector2i(-1, -1)
	if bytes[4] != 0x0D or bytes[5] != 0x0A or bytes[6] != 0x1A or bytes[7] != 0x0A:
		return Vector2i(-1, -1)
	var width := (int(bytes[16]) << 24) | (int(bytes[17]) << 16) | (int(bytes[18]) << 8) | int(bytes[19])
	var height := (int(bytes[20]) << 24) | (int(bytes[21]) << 16) | (int(bytes[22]) << 8) | int(bytes[23])
	return Vector2i(width, height)
