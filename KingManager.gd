extends Node2D

func fall_check(player, opponent):
	# This should return true if
	# - the player physically falls (i.e. crouches)
	# - they get stunned enough to have a fall anim or sth
	return false

func bleed_check(player, opponent):
	# This should return true if
	# - the player deals enough damage
	# - they get robbed (thinking using a lifestealing or favourstealing item on them or sth)
	return false

func ground_check(player, opponent):
	# This should return true if
	# - the player never jumps
	# - the player is rendered unable to jump (item prolly)
	return false

const INTERVAL_RANGE = Vector2(1, 10) # 1-10s between rules
var WORD_ACTIONS = {
	"fall": fall_check,
	"bleed": bleed_check,
	"ground": ground_check
}

func change_favour(object, amount):
	object.favour = clamp(object.favour + amount, -100, 100)

var current_interval = -1
var current_selection = null

@onready var player = get_node("../Player")
@onready var opponent = get_node("../Enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_interval <= 0:
		if current_selection != null:
			# reduce both player and opponent favour
			change_favour(player, -5)
			change_favour(opponent, -5)
		current_interval = randf_range(INTERVAL_RANGE.x, INTERVAL_RANGE.y)
		current_selection = WORD_ACTIONS.keys()[randi() % WORD_ACTIONS.size()]
	else:
		#print(current_selection)
		current_interval -= delta
		if current_selection != null:
			if WORD_ACTIONS[current_selection].call(player, opponent):
				change_favour(player, 5)
				change_favour(opponent, -5)
				current_selection = null
			elif WORD_ACTIONS[current_selection].call(opponent, player):
				change_favour(player, -5)
				change_favour(opponent, 5)
				current_selection = null
