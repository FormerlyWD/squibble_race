extends Button




func _on_pressed() -> void:
	%main_camera.position.x =$"../climate_token_shop".position.x
	$"../runner_specification".visible = true
