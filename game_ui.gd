extends CanvasLayer

signal update_bar

func _on_player_update_health(value):
	update_bar.emit(value)
