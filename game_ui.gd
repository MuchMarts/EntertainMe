extends CanvasLayer

signal update_bar
signal update_favour

func _on_player_update_health(value):
	update_bar.emit(value)


func _on_player_update_favour(value):
	update_favour.emit(value)
