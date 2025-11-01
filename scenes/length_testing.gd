extends Node


enum StatResult {
	HIGHACC,
	LOWACC,
	LOWSACC,
	HIGHSACC,
	PERFECT
}
@export var default_acc_test_modifier:float
@export var default_sacc_test_modifier:float
@export var speed_increase:float
@export var power_speed_increase:float

@onready var current_acc_test_modifier:float = default_acc_test_modifier
@onready var current_sacc_test_modifier:float = default_sacc_test_modifier
@onready var special_stat_to_runner_order:Dictionary = {
	"speed":1,
	"acc":2,
	"sacc":3
}
@onready var currently_parsed_powergrade:int = 1
@onready var currently_parsed_range:int = 0
@onready var powergrade_stat_equivalance:Dictionary = {
	1:[],
	2:[],
	3:[]
}
@onready var first_phase_complete:bool= false
@onready var position_comparisons:Dictionary = {
	1:-300, #1 = speed
	2:-300, #2 = acc
	3:-300 #3 = sacc
}
@onready var last_stat_result:StatResult
@onready var all_runners:Array[Node] = %all_runners.get_children() 
@onready var test_is_concurring:bool = true

@onready var all_build_untested:Array = [
	"acc",
	"sacc"
]
@onready var start_comparison_line:Line2D = %start_comparison_line



func reset_variables_and_runners():
	all_build_untested = [
	"acc",
	"sacc"
]
	position_comparisons = {
	1:-300, #1 = speed
	2:-300, #2 = acc
	3:-300 #3 = sacc
}
	%all_runners.retry_running_test()
	
func update_position_comparisons():
	var count:int = 0
	for runners in all_runners:
		count+=1
		if runners.position.x >= start_comparison_line.position.x:
			position_comparisons[count] = runners.position.x
	
	if position_comparisons[special_stat_to_runner_order["speed"]] > %acc_to_speed_comparison_line.position.x and all_build_untested.has("acc"):
		all_build_untested.erase("acc")
		%runner_similarity_gap_acc.start()
	if position_comparisons[special_stat_to_runner_order["acc"]] > %acc_to_speed_comparison_line.position.x and all_build_untested.has("acc"):
		all_build_untested.erase("acc")
		%runner_similarity_gap_acc.start()
	
	if position_comparisons[special_stat_to_runner_order["acc"]] > %sacc_to_acc_comparison_line.position.x and all_build_untested.has("sacc"):
		all_build_untested.erase("sacc")
		%runner_similarity_gap_sacc.start()
	if position_comparisons[special_stat_to_runner_order["sacc"]] > %sacc_to_acc_comparison_line.position.x and all_build_untested.has("sacc"):
		all_build_untested.erase("sacc")
		%runner_similarity_gap_sacc.start()


func record_test_result():
	
	powergrade_stat_equivalance[currently_parsed_powergrade].append({
		"speed":%all_runners.all_runners[special_stat_to_runner_order["speed"]-1].stats_dict["speed"],
		"acc":%all_runners.all_runners[special_stat_to_runner_order["acc"]-1].stats_dict["acceleration"],
		"sacc":%all_runners.all_runners[special_stat_to_runner_order["sacc"]-1].stats_dict["quadratic_acceleration"]
	})
	currently_parsed_range +=1
	if currently_parsed_range == 2:
		
		currently_parsed_powergrade +=1
		%all_runners.all_runners[special_stat_to_runner_order["speed"]-1].stats_dict["speed"] +=power_speed_increase
		currently_parsed_range = 0
	else:
		%all_runners.all_runners[special_stat_to_runner_order["speed"]-1].stats_dict["speed"] +=speed_increase
		

func retry_test_after_result():
	if currently_parsed_powergrade > 3:
		pass
		#("everything done")
	else:
		undo_test_loop_modifiers()
		last_stat_result = StatResult.PERFECT
		first_phase_complete = false
		reset_variables_and_runners()
		
		
		
func undo_test_loop_modifiers():
	current_acc_test_modifier = default_acc_test_modifier
	current_sacc_test_modifier = default_sacc_test_modifier
func check_for_loop_points(current_stat_result:StatResult):
	match current_stat_result:
		StatResult.HIGHACC:
			if last_stat_result == StatResult.LOWACC:
				current_acc_test_modifier /=2
		StatResult.LOWACC:
			if last_stat_result == StatResult.HIGHACC:
				current_acc_test_modifier /=2
		StatResult.HIGHSACC:
			if last_stat_result == StatResult.LOWSACC:
				current_sacc_test_modifier /=2
		StatResult.LOWSACC:
			if last_stat_result == StatResult.HIGHACC:
				current_sacc_test_modifier /=2
	last_stat_result = current_stat_result
func _on_runner_similarity_gap_timeout() -> void:
	%runner_similarity_gap_acc.stop()
	if first_phase_complete:
		return
	if position_comparisons[special_stat_to_runner_order["acc"]] >%acc_to_speed_comparison_line.position.x:
		if not position_comparisons[special_stat_to_runner_order["speed"]] >%acc_to_speed_comparison_line.position.x:
			#(StatResult.HIGHACC)
			check_for_loop_points(StatResult.HIGHACC)
			%all_runners.all_runners[special_stat_to_runner_order["acc"]-1].stats_dict["acceleration"] -= current_acc_test_modifier
			
			reset_variables_and_runners()
			return
	elif position_comparisons[special_stat_to_runner_order["speed"]] >%acc_to_speed_comparison_line.position.x:
		if not position_comparisons[special_stat_to_runner_order["acc"]] >%acc_to_speed_comparison_line.position.x:
			#(StatResult.LOWACC)
			check_for_loop_points(StatResult.LOWACC)
			%all_runners.all_runners[special_stat_to_runner_order["acc"]-1].stats_dict["acceleration"] += current_acc_test_modifier
			reset_variables_and_runners()
			return
	first_phase_complete = true
	undo_test_loop_modifiers()


func _on_runner_similarity_gap_sacc_timeout() -> void:
	%runner_similarity_gap_sacc.stop()
	if position_comparisons[special_stat_to_runner_order["sacc"]] >%sacc_to_acc_comparison_line.position.x:
		if not position_comparisons[special_stat_to_runner_order["acc"]] >%sacc_to_acc_comparison_line.position.x:
			#(StatResult.HIGHSACC)
			check_for_loop_points(StatResult.HIGHSACC)
			%all_runners.all_runners[special_stat_to_runner_order["sacc"]-1].stats_dict["quadratic_acceleration"] -= current_sacc_test_modifier
			reset_variables_and_runners()
			return
	elif position_comparisons[special_stat_to_runner_order["acc"]] >%sacc_to_acc_comparison_line.position.x:
		if not position_comparisons[special_stat_to_runner_order["sacc"]] >%sacc_to_acc_comparison_line.position.x:
			#(StatResult.LOWSACC)
			check_for_loop_points(StatResult.LOWSACC)
			%all_runners.all_runners[special_stat_to_runner_order["sacc"]-1].stats_dict["quadratic_acceleration"] += current_sacc_test_modifier
			reset_variables_and_runners()
			return
	
	#("second phase complete")
	undo_test_loop_modifiers()
	record_test_result()
	retry_test_after_result()
