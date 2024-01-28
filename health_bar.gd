extends ProgressBar

func _ready():
	self.value = 100

func update_bar(value):
	self.value = value


func _on_game_ui_update_bar(value):
	self.update_bar(value)
