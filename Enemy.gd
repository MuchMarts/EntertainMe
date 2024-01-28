extends CharacterBody2D

const SPEED = 150.0
@onready var HEALTH = 100
@onready var target = null
@onready var target_in_range = null
@onready var attack_speed = 0.5
@onready var flag = 0
@onready var anim = get_node("CollisionShape2D/AnimationPlayer")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var favour = 0

func _ready():
	add_to_group("Enemy")

func _physics_process(delta):
	if target:
		var pvelocity = global_position.direction_to(target.global_position)
		if pvelocity[0] >0:
			velocity.x = SPEED
		elif pvelocity[0] < 0:
			velocity.x = -1* SPEED
		else:
			velocity.x = 0
		
		
	move_and_slide()


func die():
	print("Im ded rofl")
	queue_free()

func take_damage(dmg):
	HEALTH -= dmg
	if HEALTH <= 0:
		die()

func _on_player_attack_enemy(dmg, target):
	print(target.name + " Took dmg: " + str(dmg) + " Health: " + str(target.HEALTH))
	target.take_damage(dmg)


func _on_detect_enemy_body_entered(body):
	if body.is_in_group("Player"):
		target = body


func _on_detect_enemy_body_exited(body):
	if body.is_in_group("Player"):
		target = null


func _on_attack_enemy_body_entered(body):
	if body.is_in_group("Player"):
		target_in_range = body


func _on_attack_enemy_body_exited(body):
	if body.is_in_group("Player"):
		target_in_range = null
