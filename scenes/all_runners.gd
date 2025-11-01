extends Node2D


@onready var all_runners:Array[Node] = get_children()
@onready var test_is_concurring:bool = false

var timeframe_initiated:bool = false
var timeframe_done:bool = false
func check_runner_order():
	all_runners = get_children()
	var count:int = 0
	for runners in all_runners:
		count+=1
		runners.runner_order = count
		runners.start_moving()

func retry_running_test():
	for runner_order in %length_testing.special_stat_to_runner_order.values():
		all_runners[runner_order-1].position.x = 0
		if runner_order > %length_testing.special_stat_to_runner_order["speed"]:
			all_runners[runner_order-1].stats_dict["speed"] = 0
		if runner_order > %length_testing.special_stat_to_runner_order["acc"]:
			all_runners[runner_order-1].stats_dict["acceleration"] = 0
func get_runner_stat_test():
	var order:int = 0
	var stat_dict:Dictionary = %length_testing.special_stat_to_runner_order
	for runner in all_runners:
		order +=1
		
		stat_dict.find_key(order)
	
func deactivate_all():
	for runner in all_runners:
		runner.current_s = runner.MovingState.STATIC
		
func _physics_process(delta: float) -> void:
	if test_is_concurring:
		%length_testing.update_position_comparisons()
