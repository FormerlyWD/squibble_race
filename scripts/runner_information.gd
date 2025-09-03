extends Node

@onready var spawn_node:Node
@onready var total_players:int = 3
@export var all_potential_names:Array[String] = [
	"Aphan",
	"Airo",
	"Az"
]
func request_new_runners() :
	for player_count in total_players:
		pass

func random_name() -> String:
	return all_potential_names[random.rng.randi_range(0,all_potential_names.size())]



	
	
