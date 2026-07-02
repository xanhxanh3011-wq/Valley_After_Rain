extends Node2D

const PlayerScene := preload("res://scenes/world/Player.tscn")
const AssetCatalog := preload("res://scripts/core/asset_catalog.gd")

func _ready() -> void:
	_setup_camera()
	_add_player()
	_add_asset_wall()
	_add_instruction_label()

func _setup_camera() -> void:
	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.position = Vector2(640, 360)
	camera.enabled = true
	add_child(camera)

func _add_player() -> void:
	var player := PlayerScene.instantiate()
	player.position = Vector2(180, 470)
	add_child(player)

func _add_asset_wall() -> void:
	_add_sample("LimeZu Adam idle_down 16x32", AssetCatalog.LIMEZU_CHARACTER_16_DIR + "Adam_idle_16x16.png", Vector2(64, 56), Rect2(32, 0, 16, 32), 3.0)
	_add_sample("LimeZu cat first frame 16x16", AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_cat.png", Vector2(360, 56), Rect2(0, 0, 16, 16), 3.0)
	_add_sample("LimeZu coffee first frame 16x16", AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_coffee.png", Vector2(640, 56), Rect2(0, 0, 16, 16), 3.0)
	_add_sample("LimeZu candle first frame 16x16", AssetCatalog.LIMEZU_ANIMATED_16_DIR + "animated_candle.png", Vector2(900, 56), Rect2(0, 0, 16, 16), 3.0)

func _add_sample(title: String, texture_path: String, position: Vector2, region: Rect2, scale_factor: float) -> void:
	var label := Label.new()
	label.text = title
	label.position = position + Vector2(0, -26)
	add_child(label)

	var sprite := Sprite2D.new()
	var atlas := AtlasTexture.new()
	atlas.atlas = AssetCatalog.load_texture(texture_path)
	atlas.region = region
	sprite.texture = atlas
	sprite.centered = false
	sprite.position = position
	sprite.scale = Vector2.ONE * scale_factor
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(sprite)

func _add_instruction_label() -> void:
	var label := Label.new()
	label.text = "ReadyRoom: WASD/arrows move the LimeZu player sample. Main demo scene is NightCafeGame."
	label.position = Vector2(32, 680)
	add_child(label)
