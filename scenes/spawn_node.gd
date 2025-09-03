extends Node



@onready var obstacle_ref:PackedScene = preload("res://objects/obstacle.tscn")
@onready var runner_ref:PackedScene = preload("res://runner/runner.tscn")
@export var starting_position_runner:int=-39
@export var runner_gap:int = 37
@export var starting_line:int = 0
@export var ending_line:int = 94
@export var dynamic_determant_line:bool = true
@export var x_gap:int = 10
@export var y_gap:float = 18.5 #manual
var total_line:int = abs(starting_line-ending_line)

var all_y_positionings:Array[float] = [
	-42,
	-23.5,
	-5,
	13.5,
	13.5+18.5,
	13.5+18.5+18.5
]
var obstacle_odds:int = 100
var obstacle_odd_requirement:int = 95
func _ready() -> void:
	pass
	#spawn_runner()

func update_total_line():
	if dynamic_determant_line:
		ending_line = %end_line_art_comp.position.x
		starting_line = %start_line_art_comp.position.x
		total_line = abs(starting_line-ending_line)
		print(total_line)
func spawn_all_obstacles():
	var all_x_parts:int = round(total_line/x_gap)-1
	var all_y_parts:int = 6
	var x_progressed_line:float = starting_line
	var y_progressed_line:float = -42
	
	for x in all_x_parts:
		x_progressed_line += x_gap
		for y in all_y_parts:
			calculate_obstacle_odds(Vector2(x_progressed_line,all_y_positionings[y]))
			y_progressed_line +=y_gap
		y_progressed_line = 0
		
func calculate_obstacle_odds(pot_position:Vector2):
	var odds:int = random.rng.randi_range(0,obstacle_odds) 
	if odds>obstacle_odd_requirement-1:
		var new_obs:CharacterBody2D = obstacle_ref.instantiate()
		%all_obstacles.add_child.call_deferred(new_obs)
		
		new_obs.position = pot_position
		
		
func spawn_runner():
	var positioning_count:int = 0
	for i in range(3):
		var new_runner:CharacterBody2D = runner_ref.instantiate()
		var runner_stats:Dictionary = runner.variance_node_ref.get_stat_from_variance(runner.variance_node_ref.get_random_variance_name())
		runner.import_dictionary_stats(new_runner,runner_stats)
		%all_runners.add_child(new_runner)
		new_runner.position.y = all_y_positionings[positioning_count]+1
		new_runner.position.x = starting_line
		
		positioning_count +=2
	
	
	
	
	
