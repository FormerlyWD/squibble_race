extends Node2D


@onready var hit_service_name_to_data = {
	
	}
func update_count():
	$"get loan".update_count()
	%user_data_panel.format_panel()
	
func put_bullet_in_queue(from:int,to:int,divider:int):
	pass


func apply_effect(bullet_name:String, applied_runner:String):
	var runner_ref:Dictionary = runner_info.runner_pool[applied_runner]
	
