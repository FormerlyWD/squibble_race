extends Button


func _on_pressed() -> void:
	field_info.apply_field_data(%field_data_table.selected_field_pool.pick_random())
	game_info.change_scene(game_info.Location.SIMULATION)
