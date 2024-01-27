extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_MODIFIER = 0.5
const TIME_BETWEEN_KEYS = 0.05 

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

func attack():
	pass

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
	
func _physics_process(delta):
	var state = 0
	var direction = 0
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
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
	
	# Goofy AF crouch
	
	if attack_seq_check:
		time += delta
		if time <= TIME_BETWEEN_KEYS and (lAttack or hAttack):
			match stored_action:
				1:
					pass
				2:
					pass
				3:
					pass
			
			attack_seq_check = 0
			stored_action = 0
	
	if direction && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 1
		time = 0
	
	if jump && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 2
		time = 0
	
	if down && !attack_seq_check:
		attack_seq_check = 1
		stored_action = 3
		time = 0
	
	
	if jump and just_movement() and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if direction and just_movement():
		var speed = SPEED
		if !down:
			anim.play("Run")
		else:
			anim.play("Crouch")
			speed *= CROUCH_MODIFIER
		velocity.x = direction * speed
	elif down and just_movement():
		anim.play("Crouch")
	elif velocity.y > 0 and just_movement():
		anim.play("Fall")
	elif velocity.y < 0 and just_movement():
		anim.play("Jump")
	elif just_movement():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")
	
	if hAttack:
		anim.play("Heavy_Attack")
	if lAttack:
		anim.play("Light_Attack")
	
	move_and_slide()

