extends CanvasLayer


func _on_r_1_pressed() -> void:
	$"..".applied_runner = runner_info.chosen_runners[0]


func _on_r_2_pressed() -> void:
	$"..".applied_runner = runner_info.chosen_runners[1]


func _on_r_3_pressed() -> void:
	$"..".applied_runner = runner_info.chosen_runners[2]


func _on_apply_pressed() -> void:
	user_data.procession.post_shop_procession()
	%main_camera.position.x = $"..".position.x
