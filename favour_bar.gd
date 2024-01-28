extends ProgressBar

func _ready():
	self.value = 100
	self.set_max(200)	
	self.show_percentage = false

func update_bar(value):
	self.value = value

func _on_game_ui_update_favour(value):
	self.update_bar(value)
