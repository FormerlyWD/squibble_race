extends Node

@onready var amount_of_runners_reached_end:int = 0
@onready var runners_ranking:Array
signal reached_end(runner_name:String)

func _ready() -> void:
	connect("reached_end",on_reached_end)
	

func on_reached_end(runner_name:String):
	print("runner_name")
	runners_ranking.append(runner_name)
	amount_of_runners_reached_end +=1
	if amount_of_runners_reached_end == 2:
		end_simulation()
		
func end_simulation():
	%all_runners.deactivate_all()

	var all_users:Array[Node] = user_data.user_collection.get_children()
	for base_user in all_users:
		
		if runner_info.chosen_runners[base_user.betted_runner_number-1] == runners_ranking[0]:
			pass
	runner_info.runner_ranking.assign(runners_ranking)
	get_tree().change_scene_to_file("res://scenes/post_simulation_stats.tscn")
