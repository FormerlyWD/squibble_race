extends Button




func _on_pressed() -> void:
	$"../all_user_modifications".apply_modifications()
	game_info.change_scene(game_info.Location.SHOPMENU)
