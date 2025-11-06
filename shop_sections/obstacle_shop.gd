extends Node2D


@onready var item_collection:PackedScene = load("res://shop_sections/items(obstacles)/obstacle_collection.tscn")
@onready var item_type:String = "obstacle"
@onready var item_pool:Dictionary = {
		"Speed Potion": {
			"effect":{
				"initial":100,
				"final":300,
				"transition_type":Tween.TransitionType.TRANS_ELASTIC,
				"targeted_stat":"speed",
				"duration":3
			},
			
			"strength":0,
			"fragile":true
		},
		
}


func reset():
	get_child(-1).queue_free()
	var new_item_collection:Node2D =item_collection.instantiate()
	add_child(new_item_collection)
	
	
	
