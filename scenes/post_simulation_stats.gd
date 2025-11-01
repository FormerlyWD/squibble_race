extends Node2D

signal PHASE_ONE_COMPLETE
@onready var premade_progress_bar:PackedScene =  load("res://scenes/progress_hud/post_simulation_progress_hud.tscn")
@export var duration_of_held_cash_animation:int = 2
@export var animation_type:Tween.TransitionType = Tween.TransitionType.TRANS_BOUNCE
@onready var before_and_after_values:Array = [
	{
		
	}
]

func initiate_animation_phase_one(runner_ranking:Array[String] = []):
	

		
		
	var all_users:Array[Node] = user_data.user_collection.get_children()
	var debug_mode:bool = false
	if runner_ranking == []:
		debug_mode = true
		var empty_string_arr:Array[String]
		var shuffled_chosen_runners:Array = runner_info.chosen_runners
		shuffled_chosen_runners.shuffle()
		empty_string_arr.assign(shuffled_chosen_runners)
		runner_ranking = empty_string_arr
		
		
	var highest_held_cash:int =0
	$all_progress_huds.plot_huds(all_users.size())
	var count:int = 0 
	for base_user in all_users:
		
		
		
		# 
		
		
		var specified_user:user =  base_user
		
		before_and_after_values.append({})
		print("count")
		before_and_after_values[count]["held_cash"] = {}
		before_and_after_values[count]["held_cash"]["before"] = specified_user.held_cash
		before_and_after_values[count]["debt"] = {}
		before_and_after_values[count]["debt"]["before"] = specified_user.debt
		before_and_after_values[count]["debt"]["after"] = specified_user.debt*game_info.debt_modifier
		if runner_info.chosen_runners[base_user.betted_runner_number-1] == runner_ranking[0]:
			print("count4")
			var runner_name:String = runner_info.chosen_runners[base_user.betted_runner_number-1]
			specified_user.held_cash *= runner_info.runner_pool[runner_name]["payout"]
			before_and_after_values[count]["held_cash"]["after"] = specified_user.held_cash
		else:
			before_and_after_values[count]["held_cash"]["after"] = specified_user.held_cash
		if specified_user.held_cash > highest_held_cash:
			highest_held_cash = specified_user.held_cash
			
		
		
		var user_progressive_hud:Node2D = $all_progress_huds.all_huds[count]
		user_progressive_hud.user_name.text = specified_user.user_name
		count +=1
	print(highest_held_cash)
	count = 0
	for progressive_hud in $all_progress_huds.all_huds:
		var designated_user:user = user_data.user_dict[count+1]
		progressive_hud.cash_progress_bar.max_value = highest_held_cash
		progressive_hud.cash_count.text = str(before_and_after_values[count]["held_cash"]["before"])
		progressive_hud.debt_count.text = str(before_and_after_values[count]["debt"]["before"])
		progressive_hud
		progressive_hud.cash_progress_bar.value = before_and_after_values[count]["held_cash"]["before"]
		
		count +=1
		
	emit_signal("PHASE_ONE_COMPLETE")
func initiate_animation_all_phases():
	initiate_animation_phase_one([])
	


func initiate_animation_phase_two():
	var count:int = 0
	print("F")
	for progressive_hud in $all_progress_huds.all_huds:
		var designated_user:user = user_data.user_dict[count+1]
		var progress_animation_tween:Tween = create_tween()
		progress_animation_tween.tween_property(progressive_hud.cash_progress_bar,
		"value",before_and_after_values[count]["held_cash"]["after"],
		duration_of_held_cash_animation).set_trans(animation_type)
		



		count +=1
		
func update_text_for_cash():
	print("yoho")
func _ready() -> void:
	print(runner_info.runner_ranking)
	PHASE_ONE_COMPLETE.connect(initiate_animation_phase_two)
	initiate_animation_phase_one(runner_info.runner_ranking)
	
	
	#game_info.create_new_game()
func _process(delta: float) -> void:
	pass

	
