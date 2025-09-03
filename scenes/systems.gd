extends Node

func parse_references():
	ref.spawn_obstacles = %spawn_obstacles
	ref.signal_win = %signal_win
	ref.UI_run = [
		%distance_of_runner_1,
		%distance_of_runner_2,
		%distance_of_runner_3
	]
func _ready() -> void:
	parse_references()
	
	ref.spawn_obstacles.update_total_line()
	#ref.spawn_obstacles.spawn_all_obstacles()
	#ref.spawn_obstacles.spawn_runner()
	%all_runners.check_runner_order()
