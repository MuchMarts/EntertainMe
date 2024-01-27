extends Node2D

@onready var _target_enemy = []
signal attack
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mid_body_entered(body):
	if body.has_method("Enemy"):
		print("Found")
		_target_enemy.append(body)


func _on_mid_body_exited(body):
	_target_enemy.erase(body)


func _on_player_get_enemy_dmg(type):
	var dmg = 0
	match type:
		0:
			dmg = 5
		1:
			dmg = 10
	for enemy in _target_enemy:
		attack.emit(dmg, enemy)
