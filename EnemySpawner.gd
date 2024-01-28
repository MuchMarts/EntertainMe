extends Node2D

const MAX_ENEMIES = 2
const SPAWN_INTERVAL = Vector2(1, 15)

var current_interval = -1

var enemy_scene = load("res://Enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_interval <= 0:
		if get_child_count() < MAX_ENEMIES:
			var en = enemy_scene.instantiate()
			en.position = Vector2(0, 766)
			en.scale = Vector2(10,10)
			add_child(en)
		current_interval = randf_range(SPAWN_INTERVAL.x, SPAWN_INTERVAL.y)
	else:
		current_interval -= delta
