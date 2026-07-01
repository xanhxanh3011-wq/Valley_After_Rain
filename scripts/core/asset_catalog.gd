class_name AssetCatalog

const TILE_SIZE := 32

const MODERN_INTERIOR_GENERIC := "res://assets/art/modern_interiors/interiors_32x32/Theme_Sorter_32x32/1_Generic_32x32.png"
const MODERN_INTERIOR_KITCHEN := "res://assets/art/modern_interiors/interiors_32x32/Theme_Sorter_32x32/12_Kitchen_32x32.png"
const MODERN_PLAYER_ADAM := "res://assets/art/modern_interiors/characters_32x32/Adam_32x32.png"
const MODERN_UI := "res://assets/art/modern_interiors/ui/UI_32x32.png"
const MODERN_CHARACTER_DIR := "res://assets/art/modern_interiors/characters_32x32/"
const MODERN_ANIMATED_DIR := "res://assets/art/modern_interiors/animated_objects_32x32/"

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
