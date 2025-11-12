extends Node2D



func update_all_distance_ui():
	var count:int = 0
	for dist_ui in get_children():
		dist_ui.update_ui(count)
		count +=1
