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
	for item_process in post_shop_procession_list:
			match item_process["item_type"]:
				"power_card":
					item_type_to_dedicated_shop["power_card"].apply_effect(item_process)
				"climate_token":
					item_type_to_dedicated_shop["climate_token"].apply_effect(item_process)
			post_shop_procession_list.erase(item_process)
