extends Node



@onready var obstacle_ref:PackedScene = preload("res://objects/obstacle.tscn")
@onready var runner_ref:PackedScene = preload("res://runner/runner.tscn")


@export var obstacle_odds:int = 100
@export var obstacle_odd_requirement:int = 95
@export var chance_roll_amount:int = 5
@onready var roll_amount_succeeded:int = 0
@onready var all_potential_obstacle_placements:Array
@onready var line_listed_obstacle_placements:Array[Array] = [
	[],
	[],
	[],
	[],
	[],
	[],
	[],
	[]
]
func _ready() -> void:
	pass
	#spawn_runner()

func update_total_line():
	if %measurement_points.dynamic_determant_line:
		%measurement_points.ending_line = %end_line_art_comp.position.x
		%measurement_points.starting_line = %start_line_art_comp.position.x
		%measurement_points.total_line = abs(%measurement_points.starting_line-%measurement_points.ending_line)
		print(%measurement_points.total_line)
	
func spawn_unique_obstacle(item_dict:Dictionary, applied_runner:String):
	
	var runner_count:int = runner_info.chosen_runners.find(applied_runner)

	var line_num:int  = (runner_count)*2+1
	var coord:Vector2 = line_listed_obstacle_placements[line_num].pick_random()
	
	var new_type:String = (field_info.chosen_weather+field_info.artificial_weather).pick_random()
	var new_obs:CharacterBody2D = obstacle_ref.instantiate()
	new_obs.position = coord
	new_obs.change_image(item_dict["image"])
	new_obs.strength = item_dict["strength"]
	new_obs.fragile = item_dict["fragile"]
	if runner_info.typings_ref.all_obstacle_type_to_color.has(new_type):
		new_obs.modulate = Color(runner_info.typings_ref.all_obstacle_type_to_color[new_type])
	%all_obstacles.add_child.call_deferred(new_obs)
	new_obs.obstacle_type = new_type
	if not item_dict["effect"].size() == 0:
		new_obs.effect = item_dict["effect"]
	
func spawn_obstacle_from_random_line(runner_count:int):
	var line_num:int  = (runner_count-1)*2
	var coord:Vector2 = line_listed_obstacle_placements[line_num].pick_random()
func spawn_all_obstacles():
	var all_x_parts:int = round(%measurement_points.total_line/%measurement_points.x_gap)-1
	var all_y_parts:int = 6
	var x_progressed_line:float = %measurement_points.starting_line
	var y_progressed_line:float = -47.25
	

	for x in all_x_parts:
		y_progressed_line = -47.25
		x_progressed_line += %measurement_points.x_gap
		if x <= %measurement_points.barrier_for_obstacle_generation or x >= all_x_parts-%measurement_points.barrier_for_obstacle_generation:
			# barrier
			pass
		else:
			for y in all_y_parts:
				line_listed_obstacle_placements[y].append(Vector2(x_progressed_line,y_progressed_line))
				all_potential_obstacle_placements.append(Vector2(x_progressed_line,y_progressed_line))
				y_progressed_line +=%measurement_points.y_gap
				
			y_progressed_line = -47.25
			
	all_potential_obstacle_placements.shuffle()
	if all_potential_obstacle_placements.size() < chance_roll_amount:
		chance_roll_amount = all_potential_obstacle_placements.size()
	for count in chance_roll_amount:
		var odds:int = random.rng.randi_range(100,obstacle_odds) 
		if odds>=obstacle_odd_requirement:
			spawn_normal_obstacle(all_potential_obstacle_placements[count] )
	
func spawn_normal_obstacle(coordinates:Vector2, effect:Dictionary = {}):

	var new_type:String = (field_info.chosen_weather+field_info.artificial_weather).pick_random()
	var new_obs:CharacterBody2D = obstacle_ref.instantiate()
	new_obs.position = coordinates
	if runner_info.typings_ref.all_obstacle_type_to_color.has(new_type):
		print(new_type)
		new_obs.modulate = Color(runner_info.typings_ref.all_obstacle_type_to_color[new_type])
	%all_obstacles.add_child.call_deferred(new_obs)
	new_obs.obstacle_type = new_type
	if not effect.size() == 0:
		new_obs.effect = effect
func calculate_obstacle_odds(pot_position:Vector2):
	var odds:int = random.rng.randi_range(100,obstacle_odds) 
	if odds>=obstacle_odd_requirement:
		var new_obs:CharacterBody2D = obstacle_ref.instantiate()
		%all_obstacles.add_child.call_deferred(new_obs)
		
		new_obs.position = pot_position
		
		
func spawn_runner():
	var positioning_count:int = 0
	if runner_info.chosen_runners.size() == 0:
		for runner_count in range(3):
			var new_runner:CharacterBody2D = runner_ref.instantiate()
			%all_runners.add_child(new_runner)
			new_runner.position.y = %measurement_points.all_y_positionings[positioning_count]+1
			new_runner.position.x = %measurement_points.starting_line
			
			positioning_count +=2
		return
	else:
		for runner_count in range(3):
			var new_runner:CharacterBody2D = runner_ref.instantiate()
			var runner_stats:Dictionary = runner_info.runner_pool[runner_info.chosen_runners[runner_count]].duplicate()
			new_runner.apply_stats(runner_stats)
			new_runner.start_moving()
			%all_runners.add_child(new_runner)
			
			new_runner.position.y = %measurement_points.all_y_positionings[positioning_count]+1
			new_runner.position.x = %measurement_points.starting_line
			
			positioning_count +=2
	
	
	
	
	
