class_name AssetCatalog

const TILE_SIZE := 16

const LIMEZU_ANIMATED_16_DIR := "res://assets/limezu/animated_objects/16x16/spritesheets/"
const LIMEZU_CHARACTER_16_DIR := "res://assets/limezu/characters_free/16x16/"

const SUPER_RETRO_EXTERIOR := "res://assets/art/super_retro_world/exterior/atlas_32x.png"
const SUPER_RETRO_INTERIOR := "res://assets/art/super_retro_world/interior/atlas_32x.png"
const SUPER_RETRO_WATER := "res://assets/art/super_retro_world/animations/water_transparent.png"

const SHIKASHI_ICONS_TRANSPARENT := "res://assets/art/icons/shikashi/#1 - Transparent Icons.png"
const SHIKASHI_ICONS_SHADOW := "res://assets/art/icons/shikashi/#2 - Transparent Icons & Drop Shadow.png"

static func load_texture(path: String) -> Texture2D:
	var texture := load(path) as Texture2D
	if texture == null:
		push_error("Missing texture: %s" % path)
	return texture
