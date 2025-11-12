extends Node

@onready var assigned_controller:int = 1

func next_user():
	
	
	
	
	assigned_controller +=1
	(assigned_controller)
	
	if assigned_controller > $"..".amount_of_users:
		$"..".emit_signal("finished_user_cycle")
		assigned_controller = 1
		("finished")
		return

	user_data.current_user = user_data.get_controller()
	$"..".emit_signal("next_user")
	if user_data.current_user.betted_runner_number == 0:
		$"..".emit_signal("new_runner_selection",1)
	
