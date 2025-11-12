extends Node2D


@onready var item_collection:PackedScene = load("res://shop_sections/items(obstacles)/obstacle_collection.tscn")
@onready var item_type:String = "obstacle"
@onready var item_pool:Dictionary = {
		"Speed Potion": load("res://shop_sections/obstacle_shop/obstacle_resource/obstacle_resource_pool/obstacle.tres")
		
}



func reset():
	get_child(-1).queue_free()
	var new_item_collection:Node2D =item_collection.instantiate()
	add_child(new_item_collection)

	
	
