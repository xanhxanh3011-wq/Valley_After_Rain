class_name AssetCatalog

const TILE_SIZE := 16

const LIMEZU_ANIMATED_16_DIR := "res://assets/limezu/animated_objects/16x16/spritesheets/"
const LIMEZU_ANIMATED_16_GIF_DIR := "res://assets/limezu/animated_objects/16x16/gif/"
const LIMEZU_CHARACTER_16_DIR := "res://assets/limezu/characters_free/16x16/"

static func load_texture(path: String) -> Texture2D:
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Missing texture: %s" % path)
	return texture
