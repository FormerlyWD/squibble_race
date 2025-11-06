extends CanvasLayer

@onready var selected_runner:String = runner_info.chosen_runners[0]
func _on_r_1_pressed() -> void:
	selected_runner = runner_info.chosen_runners[0]


func _on_r_2_pressed() -> void:
	selected_runner = runner_info.chosen_runners[1]


func _on_r_3_pressed() -> void:
	selected_runner = runner_info.chosen_runners[2]


func _on_apply_pressed() -> void:
	%main_camera.position.x = $"..".position.x
	%runner_specification.visible = false
