extends SceneTree

var failed := false

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: Variant = load("res://scenes/main/NightCafeGame.tscn")
	_require(scene != null, "Cannot load NightCafeGame scene")
	if failed:
		quit(1)
		return

	var game: Variant = scene.instantiate()
	root.add_child(game)
	await process_frame

	game._show_recipe_book()
	await process_frame
	_require(game.overlay_root != null and game.overlay_root.visible, "Recipe book overlay is not visible")
	_require(game.bottom_panel != null and game.bottom_panel.modulate.a < 1.0, "Bottom panel is not dimmed while recipe book is open")
	game._close_book_overlay()
	await process_frame
	_require(not game.overlay_root.visible, "Recipe book overlay did not close")

	game._show_notebook()
	await process_frame
	_require(game.overlay_root.visible, "Notebook overlay is not visible")
	game._close_book_overlay()
	await process_frame

	game._reset_state()
	game._show_prep()
	await process_frame
	_require(game.data.get("nights", []).size() >= 20, "Production night patch was not merged")
	_require(game.data.get("recipes", []).size() >= 45, "Production recipe patch was not merged")
	game._start_night()
	await process_frame
	_require(not game.current_visit.is_empty(), "No first customer after starting night")
	_require(game.walking_customer != null, "Customer walk-in sprite was not created")

	quit(1 if failed else 0)

func _require(condition: bool, message: String) -> void:
	if condition:
		return
	failed = true
	push_error("[smoke] %s" % message)
