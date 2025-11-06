extends Node

@onready var bullet_pool_file:String = "res://shop_sections/assasination/bullet_pool/"
@onready var bullet_collection:PackedScene = preload("res://shop_sections/assasination/bullet_collection.tscn")
@onready var item_type:String = "assasination"
@onready var hit_service_pool = {
		"Low dmg": {
			"base_chance":450,
			"division_modifier":1,
			"health_depletion":2
		}
	}
@onready var hit_service_name_to_data = {
	
	}



func reset():
	get_child(-1).queue_free()
	var new_collection:Node2D = bullet_collection.instantiate()
	add_child(new_collection)
	apply_automatic_data_for_all_bullets()


func apply_automatic_data_for_all_bullets():
	var children_array:Array[Node] = get_child(-1).get_children()
	for bullet in children_array:
		print("is this looping?")
		var specified_bullet:item = bullet
		var rng_range_data:Dictionary = hit_service_pool[specified_bullet.item_name]
		specified_bullet.is_description_dynamic = true
		specified_bullet.dynamic_description_scriptholder = self
		
		specified_bullet.item_type = item_type
		
		

func generate_description(item_name:String) -> String:
	var rng_range_data:Dictionary = hit_service_pool[item_name]
	return "selected runner is" + %runner_specification.selected_runner
	
func put_bullet_in_queue(from:int,to:int,divider:int):
	pass

func calculate_chance(percentage:float) -> bool:
	var random_num:int = randi_range(0,100)
	if percentage > random_num:
		return true
	return false
func apply_effect(item_data:Dictionary):
	var health_chance_data:Dictionary =  hit_service_pool[item_data["item_name"]]
	var runner_ref:Dictionary = runner_info.runner_pool[item_data["applied_runner"]]
	
	
	runner_ref["health"] -= health_chance_data["health_depletion"] 
	if runner_ref["health"] <= 0:
		runner_ref["health"] = 0
		runner_ref["body_state"] = "dead"
		print("already dead")
		return
	var hit_percentage_chance:float= health_chance_data["base_chance"]/(runner_ref["health"]*health_chance_data["division_modifier"])
	
	
	if calculate_chance(hit_percentage_chance):
		runner_ref["health"] = 0
		runner_ref["body_state"] = "dead"
		return
		
	
