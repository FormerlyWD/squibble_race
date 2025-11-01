extends Button



func _on_pressed() -> void:
	user_data.get_controller().betted_runner_number = int(str(get_parent().name))


func _on_confirm_pressed() -> void:
	pass # Replace with function body.
