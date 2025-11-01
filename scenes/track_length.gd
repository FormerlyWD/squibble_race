extends Node
@export var starting_position_runner:int=-39
@export var runner_gap:int = 37
@export var starting_line:float = 0
@export var ending_line:float = 100
@export var dynamic_determant_line:bool = true
@export var x_gap:int = 10
@export var y_gap:float = 18.5 #manual
@export var barrier_for_obstacle_generation:int = 2



var total_line:float = abs(starting_line-ending_line)

var all_y_positionings:Array[float] = [
	-42,
	-23.5,
	-5,
	13.5,
	13.5+18.5,
	13.5+18.5+18.5
]
