extends Node2D

@onready var _target_enemy = []
@onready var atk_dmg = 0
signal attack
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mid_body_entered(body):
	if body.is_in_group("Enemy"):
		_target_enemy.append(body)
		attack.emit(atk_dmg, body)


func _on_mid_body_exited(body):
	if body.is_in_group("Enemy"):
		_target_enemy.erase(body)


func _on_player_get_enemy_dmg(type):
	var dmg = 0
	match type:
		0:
			atk_dmg = 5
		1:
			atk_dmg = 10
