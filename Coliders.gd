extends Node2D

@onready var target = 0

signal target_found

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_detect_enemy_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		target_found.emit(body)


func _on_detect_enemy_body_exited(body):
	target = 0
	target_found.emit(target)
