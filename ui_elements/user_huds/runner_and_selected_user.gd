extends MarginContainer

@onready var distance_label:Label = $distance
@onready var all_betted_user_names:VBoxContainer = $all_betted_users

func update_ui(runner_number:int):
	if game_info.debug_mode:
		return
	var runner_name:String = runner_info.chosen_runners[runner_number]
	for base_user in user_data.user_collection.get_children():
		if base_user.betted_runner_number-1 == runner_number:
			
			var line_edit:LineEdit = LineEdit.new()
			line_edit.editable = false
			line_edit.set("theme_override_font_sizes/font_size", 128)
			line_edit.text = base_user.user_name
			
			$all_betted_users.add_child(line_edit)
