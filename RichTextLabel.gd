extends RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	self.text = "testing"

func _on_game_ui_update_input_buffer(value):
	var formated: String = ""
	
	while value:
		var frame_d: Array = value.pop_back()
		formated += " " + "".join(frame_d)
	
	self.text = formated
