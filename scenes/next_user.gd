extends Button


func _on_pressed() -> void:
	user_data.emit_signal("next_user")
	
