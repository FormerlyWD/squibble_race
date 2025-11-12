extends Node

@onready var on_simulation_procession_list:Array[Dictionary]
@onready var post_shop_procession_list:Array[Dictionary]
@onready var item_type_to_dedicated_shop:Dictionary= {
	
}

func simulation_procession():
	for item_process in on_simulation_procession_list:
			match item_process["item_type"]:
				"obstacle":
					ref.spawn_obstacles.spawn_unique_obstacle(item_process["item_data"], item_process["applied_runner"])
					
			on_simulation_procession_list.erase(item_process) 
func post_shop_procession():
	print(post_shop_procession_list.size())
	for count in post_shop_procession_list.size():
		var item_process = post_shop_procession_list[0]
		print("yo")
		item_type_to_dedicated_shop[item_process["item_type"]].apply_effect(item_process)
		post_shop_procession_list.erase(item_process)
