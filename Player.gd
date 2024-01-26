extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_MODIFIER = 0.5
@onready var PREV = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_parent()
@onready var is_crouch = 0
@onready var anim = get_node("AnimationPlayer")
@onready var is_attack = 0
@onready var attack_type = 0

func attack():
	match attack_type:
		0: 
			anim.play("Light_Attack")
		1:
			anim.play("Heavy_Attack")

func _physics_process(delta):
	var state = 0
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	
	var direction = 0
	
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
			
	# Goofy AF crouch
	var speed = SPEED

	if direction:
		state = 1
	if down:
		state = 4
		speed *= CROUCH_MODIFIER
	# Handle jump.
	if (Input.is_action_just_pressed("up") and is_on_floor()):
		velocity.y = JUMP_VELOCITY
	if velocity.y < 0:
		state = 2
	if velocity.y > 0:
		state = 3
	
	if Input.is_action_just_pressed("light_attack"):
		attack_type = 0
		state = 5
	if Input.is_action_just_pressed("heavy_attack"):
		attack_type = 1
		state = 5
	
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	match state:
		0: 
			velocity.x = move_toward(velocity.x, 0, SPEED)
			anim.play("Idle")
		1: 
			velocity.x = direction * speed
			anim.play("Run")
		2: 
			anim.play("Jump")			
		3: 
			anim.play("Fall")	
		4: 
			anim.play("Crouch")
		5: 
			attack()
		_:
			print("This should not happen")
			anim.play("Idle")
	move_and_slide()

