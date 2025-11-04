extends Button


@onready var runner_conformation_number:int = int(str(get_parent().name))
@onready var unselected_text:String = "SLCT"
@onready var selected_text:String = "{SELECTED}"
func _ready() -> void:
	user_data.new_runner_selection.connect(on_new_runner_selection)
	
func _on_pressed() -> void:
	user_data.emit_signal("new_runner_selection",runner_conformation_number)
func on_new_runner_selection(runner_number:int):
	if runner_conformation_number == runner_number:
		text =selected_text
		user_data.current_user.betted_runner_number = int(str(get_parent().name))
	else:
		text = unselected_text
func _on_confirm_pressed() -> void:
	pass # Replace with function body.
