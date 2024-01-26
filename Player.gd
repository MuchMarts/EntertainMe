extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const CROUCH_MODIFIER = 0.5
@onready var PREV = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = get_node(".")
@onready var is_crouch = 0
@onready var flag = 0
@onready var anim = get_node("AnimationPlayer")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var down = Input.is_action_pressed("down")
	
	var direction = 0
	# set previos button
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
		
	
	print(direction)
	print(PREV)
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	
	var speed = SPEED
	if down:
		if !is_crouch:
			player.scale /= 2
			is_crouch = 1
		speed *= CROUCH_MODIFIER
		
	else:
		if is_crouch:
			player.scale *= 2
			is_crouch = 0
		speed = SPEED
	
	if direction:
		velocity.x = direction * speed
		if velocity.y == 0:
			anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")

	move_and_slide()
