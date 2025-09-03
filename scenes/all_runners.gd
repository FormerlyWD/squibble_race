extends Node2D

func check_runner_order():
	pass
	var count:int = 0
	for runners in get_children():
		count+=1
		runners.runner_order = count
