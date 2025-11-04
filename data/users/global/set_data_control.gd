extends Node

@onready var assigned_controller:int = 0

func next_user():
	
	
	
	
	assigned_controller +=1
	print(assigned_controller)
	
	if assigned_controller > %user_collection_and_generation.amount_of_users:
		$"..".emit_signal("finished_user_cycle")
		assigned_controller = 1
	
	user_data.current_user = user_data.get_controller()
	
	if user_data.current_user.betted_runner_number == 0:
		$"..".emit_signal("new_runner_selection",1)
	
