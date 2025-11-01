extends Node

@onready var assigned_controller:int = 1

func next_user():
	
	
	assigned_controller +=1
	
	
	
	if assigned_controller > %user_collection_and_generation.amount_of_users:
		$"..".emit_signal("finished_user_cycle")
		assigned_controller = 1

	user_data.current_user = user_data.get_controller()
	$"..".emit_signal("next_user")
