extends Button



func _on_pressed() -> void:
	if not %field_data_table.user_checklist.has(user_data.get_controller().user_number):
		%field_data_table.selected_field_pool.append(int(str(get_parent().name)))
		%field_data_table.user_checklist.append(user_data.get_controller().user_number)
	else:
		pass
		#("user already decided")
	
