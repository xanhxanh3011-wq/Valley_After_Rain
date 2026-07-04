extends SceneTree
func _initialize():
	var p = ProjectSettings.globalize_path("res://assets/generated/ui/icons_16x16/coffee.png")
	print(p)
	print(FileAccess.file_exists(p))
	var img = Image.new()
	var err = img.load(p)
	print(err)
	if err == OK:
		print(img.get_size())
	quit()
