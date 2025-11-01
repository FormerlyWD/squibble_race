extends Node2D

@onready var premade_progress_bar:PackedScene =  load("res://scenes/progress_hud/post_simulation_progress_hud.tscn")
@onready var all_x_points:Array[float]
@onready var all_huds:Array[Node2D]
@onready var default_y:float
@onready var width_of_progress_hud:float = (533+303)/2
@onready var width_gap:float = 30/2


func plot_huds(amount:int):
	for point in amount:
		
		var pos:Vector2 =  Vector2(point*(width_of_progress_hud+width_gap)- (amount-1)*(width_of_progress_hud/2+width_gap/2), default_y)
		var hud:Node2D = premade_progress_bar.instantiate()
		add_child(hud)
		hud.position = pos
		all_huds.append(hud)
		
	
		
