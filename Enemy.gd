extends CharacterBody2D

@onready var HEALTH = 100

@onready var anim = get_node("CollisionShape2D/AnimationPlayer")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var favour = 0

func _ready():
	add_to_group("Enemy")

func _physics_process(delta):
	pass

func die():
	print("Im ded rofl")
	pass

func take_damage(dmg):
	HEALTH -= dmg
	if HEALTH <= 0:
		die()
	

func _on_player_attack_enemy(dmg, target):
	print(target.name + " Took dmg: " + str(dmg) + " Health: " + str(target.HEALTH))
	target.take_damage(dmg)
