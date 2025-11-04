extends Button

@export var shop_name:String


func _on_pressed() -> void:
	%main_camera.position.x = $"../../..".item_type_to_dedicated_shop[shop_name].position.x
	%runner_specification.visible = true
