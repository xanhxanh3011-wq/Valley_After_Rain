extends CharacterBody2D

@export var speed := 180.0

@onready var sprite: Sprite2D = $Sprite2D

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()

	if direction.x != 0.0:
		sprite.flip_h = direction.x < 0.0
