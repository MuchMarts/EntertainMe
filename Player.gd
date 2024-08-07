extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const CROUCH_MODIFIER: float = 0.5
const TIME_BETWEEN_KEYS: float = 0.05 
const MAX_HEALTH: int = 100
const FRAME_TIME: float = 1.0 / 60.0

var INPUT_BUFFER: Array = []
var BUFFER_POINTER: int = 0
var BUFFER_SIZE: int = 20 # How many frames of data are we storing
var BUFFER_PUSH_TIME: float = 0.0 
var BUFFER_TEMP_MOVES: Array = []
var BUTTON_STATES: Array = [0, 0, 0, 0, 0, 0]

signal get_enemy_dmg
signal attack_enemy
signal update_health
signal update_favour
signal ping_king
signal input_buffer
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
@onready var favour = 0
#jank way to detect wheter favour has been updated
@onready var ffavour = 0
@onready var player_health = 90

# King Tasks
@onready var damage_dealt_overtime = 0
@onready var has_jumped = 0
@onready var has_crouched = 0

func _ready():
	add_to_group("Player")

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
	var newHealth = float(player_health) / float(MAX_HEALTH)
	update_health.emit(int(newHealth * 100))

func change_favour():
	update_favour.emit(favour + 100)
	ffavour = favour

func die():
	get_tree().change_scene_to_file("res://tryAgain.tscn")
	queue_free()

func _physics_process(delta):
	if player_health <= 0:
		if anim.is_playing():
			return
		anim.play("Death")

	if favour != ffavour:
		change_favour()

	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	BUTTON_STATES[0] = Input.is_action_pressed("left")
	BUTTON_STATES[1] = Input.is_action_pressed("right")
	BUTTON_STATES[2] = Input.is_action_pressed("down")
	BUTTON_STATES[3] = Input.is_action_pressed("up")
	BUTTON_STATES[4] = Input.is_action_pressed("light_attack")
	BUTTON_STATES[5] = Input.is_action_pressed("heavy_attack")
	
	BUFFER_PUSH_TIME += delta
	
	if BUFFER_PUSH_TIME < FRAME_TIME:
		BUFFER_TEMP_MOVES.append(BUTTON_STATES)
	
	if BUFFER_PUSH_TIME >= FRAME_TIME:
		BUFFER_TEMP_MOVES.append(BUTTON_STATES)
		var b_states = [0,0,0,0,0,0]
		
		for i in range(len(BUTTON_STATES)):
			for b in BUFFER_TEMP_MOVES:
				if b[i]:
					b_states[i] = 1
					break	
		
		
		if BUFFER_POINTER >= BUFFER_SIZE:
			BUFFER_POINTER = BUFFER_POINTER % BUFFER_SIZE
			INPUT_BUFFER[BUFFER_POINTER] = b_states
		elif len(INPUT_BUFFER) < BUFFER_SIZE:
			INPUT_BUFFER.append(b_states)
		else:
			INPUT_BUFFER[BUFFER_POINTER] = b_states
		BUFFER_TEMP_MOVES = []
		BUFFER_PUSH_TIME = 0.0
		BUFFER_POINTER += 1
		input_buffer.emit(INPUT_BUFFER, BUFFER_POINTER)
	
	# TODO: Do State Magic
	
	
func _on_colliders_attack(dmg, target):
	attack_enemy.emit(dmg, target)
	damage_dealt_overtime += dmg


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Death":

		die()


func _on_king_manager_start_task():
	has_crouched = 0
	damage_dealt_overtime = 0
	has_jumped = 0


func _on_king_manager_ping_player(case):
	match case:
		0:
			if has_crouched:
				ping_king.emit(0, 1)
		1:
			ping_king.emit(1, damage_dealt_overtime)
			change_favour()
		2:
			if has_jumped:
				ping_king.emit(2, 1)
