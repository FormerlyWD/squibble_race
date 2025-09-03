extends Node

signal reached_end(runner_name:String)

func _ready() -> void:
	connect("reached_end",on_reached_end)
	

func on_reached_end(runner_name:String):
	print(runner_name)
	
