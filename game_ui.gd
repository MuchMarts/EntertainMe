extends CanvasLayer

signal update_bar
signal update_favour
signal update_input_buffer

func _on_player_update_health(value):
	update_bar.emit(value)


func _on_player_update_favour(value):
	update_favour.emit(value)


func _on_player_input_buffer(value, pointer):
	var sorted_values: Array = []
	
	for i in range(len(value)):
		var relative_pos: int = i + pointer
		if relative_pos >= len(value):
			sorted_values.append(value[relative_pos % len(value)])
		else:
			sorted_values.append(value[relative_pos])
	
	update_input_buffer.emit(sorted_values)
