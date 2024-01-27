extends CharacterBody2D

@onready var anim = get_node("CollisionShape2D/AnimationPlayer")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	anim.play("Idle")
	pass
func Enemy():
	pass


func _on_player_attack_enemy(dmg, target):
	print("Owwie")
	print(dmg)
