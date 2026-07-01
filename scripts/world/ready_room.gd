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
	_add_sample("Modern interiors 32x32", AssetCatalog.MODERN_INTERIOR_GENERIC, Vector2(64, 56), 0.5)
	_add_sample("Super Retro exterior atlas", AssetCatalog.SUPER_RETRO_EXTERIOR, Vector2(520, 56), 1.0)
	_add_sample("Super Retro interior atlas", AssetCatalog.SUPER_RETRO_INTERIOR, Vector2(520, 360), 1.0)
	_add_sample("Shikashi icons", AssetCatalog.SHIKASHI_ICONS_TRANSPARENT, Vector2(900, 56), 0.5)
	_add_sample("Modern UI", AssetCatalog.MODERN_UI, Vector2(900, 560), 1.0)

func _add_sample(title: String, texture_path: String, position: Vector2, scale_factor: float) -> void:
	var label := Label.new()
	label.text = title
	label.position = position + Vector2(0, -26)
	add_child(label)

	var sprite := Sprite2D.new()
	sprite.texture = AssetCatalog.load_texture(texture_path)
	sprite.centered = false
	sprite.position = position
	sprite.scale = Vector2.ONE * scale_factor
	add_child(sprite)

func _add_instruction_label() -> void:
	var label := Label.new()
	label.text = "ReadyRoom: WASD/arrows move the placeholder player. Replace this scene once the game idea is decided."
	label.position = Vector2(32, 680)
	add_child(label)
