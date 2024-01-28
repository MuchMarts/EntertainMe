extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_MODIFIER = 0.5
const TIME_BETWEEN_KEYS = 0.05 
const MAX_HEALTH = 100

signal get_enemy_dmg
signal attack_enemy
signal update_health

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var PREV = 0
@onready var player = get_parent()
@onready var is_crouch = 0
@onready var anim = get_node("AnimationPlayer")
@onready var mid_col
@onready var attack_type = 0
@onready var attack_seq_check = 0
@onready var stored_action = 0
@onready var time = 0
@onready var crouch_flag = 0
@onready var player_health = 90

func just_movement():
	if anim.current_animation == "Idle":
		return true
	if anim.current_animation == "Run":
		return true
	if anim.current_animation == "Jump":
		return true
	if anim.current_animation == "Crouch":
		return true
	if anim.current_animation == "Fall":
		return true
	# if no animation is playing you can do movement
	if !anim.is_playing():
		return true
	return false

func is_attacking():
	if anim.current_animation.contains("Attack") and anim.is_playing():
		return true
	return false
	
func change_health():
	print("Here2")
	var newHealth = float(player_health) / float(MAX_HEALTH)
	update_health.emit(int(newHealth * 100))

func die():
	get_tree().change_scene_to_file("res://tryAgain.tscn")
	queue_free()

func _physics_process(delta):
	var state = 0
	var direction = 0
	
	if player_health <= 0:
		if anim.is_playing():
			return
		anim.play("Death")
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	var up = Input.is_action_pressed("up")
	var jump = Input.is_action_just_pressed("up")
	var lAttack = Input.is_action_just_pressed("light_attack")
	var hAttack = Input.is_action_just_pressed("heavy_attack")
	
	

	
	# Nullify previous input so player cant stop if left and right are pressed at the same time
	if left != false && right == false:
		PREV = -1
		direction = -1
	elif right != false && left == false:
		PREV = 1
		direction = 1
	
	if left == true && right == true:
		if PREV == 1:
			direction = -1
		elif PREV == -1:
			direction = 1
	
	if direction == -1:
		if get_node("AnimatedSprite2D").scale.x >= 0:
			get_node("AnimatedSprite2D").scale.x *= -1 
	elif direction == 1:
		if get_node("AnimatedSprite2D").scale.x < 0:
			get_node("AnimatedSprite2D").scale.x *= -1 
	
	
	if attack_seq_check and not is_attacking():
		time += delta
		var flag = 1
		if time <= TIME_BETWEEN_KEYS and (lAttack or hAttack):
			if hAttack: 
				stored_action += 1
			flag = 0
			match stored_action:
				1:
					anim.play("Light_Attack_Top")
					get_enemy_dmg.emit(0)
				2:
					anim.play("Heavy_Attack_Top")
					get_enemy_dmg.emit(1)
				3:
					anim.play("Light_Attack_Mid")
					get_enemy_dmg.emit(0)
				4:
					anim.play("Heavy_Attack_Mid")
					get_enemy_dmg.emit(1)
				5:
					anim.play("Light_Attack_Bot")
					get_enemy_dmg.emit(0)
				6:
					anim.play("Heavy_Attack_Bot")
					get_enemy_dmg.emit(1)
			
			time = 0
			attack_seq_check = 0
			stored_action = 0
		
		elif time >= TIME_BETWEEN_KEYS:
			if just_movement() and is_on_floor() and (jump or stored_action == 1):
				velocity.y = JUMP_VELOCITY
			
			time = 0
			attack_seq_check = 0
			stored_action = 0

	elif !direction and (lAttack or hAttack) and not is_attacking():
		if lAttack:
			anim.play("Light_Attack_Mid")
			get_enemy_dmg.emit(0)
		if hAttack:
			anim.play("Heavy_Attack_Mid")
			get_enemy_dmg.emit(1)
			
	if (up or velocity.y < 0) && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 1
		time = 0
	
	if down && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 5
		time = 0
		
	if direction && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 3
		time = 0	
	
	if not down and crouch_flag:
		crouch_flag = 0
		get_node("CollisionShape2D").disabled = false
		get_node("CollisionShape2D2").disabled = true
	
	if direction and just_movement():
		var speed = SPEED
		if !down:
			anim.play("Run")
		else:
			anim.play("Crouch")
			speed *= CROUCH_MODIFIER
			crouch_flag = 1
			get_node("CollisionShape2D").disabled = true
			get_node("CollisionShape2D2").disabled = false
		velocity.x = direction * speed
	elif down and just_movement():
		anim.play("Crouch")
		crouch_flag = 1
		get_node("CollisionShape2D").disabled = true
		get_node("CollisionShape2D2").disabled = false
	elif velocity.y > 0 and just_movement():
		anim.play("Fall")
	elif velocity.y < 0 and just_movement():
		anim.play("Jump")
	elif just_movement():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")

	move_and_slide()

func _on_colliders_attack(dmg, target):
	attack_enemy.emit(dmg, target)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death":
		die()
