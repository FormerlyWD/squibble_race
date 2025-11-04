extends Node2D

signal data_ready

@onready var pixel_art_scale:int = 10
@onready var applied_runner:String
@onready var item_type_to_dedicated_shop:Dictionary= {
	"power_card":$power_card_shop,
	"obstacle":$obstacle_shop,
	"climate_token":$climate_token_shop,
	"bank":$bank
}


func game_ready():
	dupelicate_item_type_matching()
func round_ready():

	on_next_user() # burst
func on_next_user():
	
	%user_data_panel.format_panel()
	%data_table.generate_dictionary()
	%field_data_table.generate_dictionary()
	item_type_to_dedicated_shop["bank"].update_count()
	item_type_to_dedicated_shop["power_card"].reset(3)
	item_type_to_dedicated_shop["climate_token"].reset()
func parsed_all_users():
	
	
	
	field_info.apply_field_data(%field_data_table.selected_field_pool.pick_random())
	
	game_info.change_scene(game_info.Location.SIMULATION)
func _ready() -> void:
	
	
	user_data.current_user = user_data.get_controller()
	
	user_data.next_user.connect(on_next_user)
	user_data.finished_user_cycle.connect(parsed_all_users)
	game_info.pick_data()
	user_data.emit_signal("next_user")
	game_ready()
	
	
func dupelicate_item_type_matching():
	user_data.procession.item_type_to_dedicated_shop = item_type_to_dedicated_shop.duplicate()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			item_click_detection()
			
func on_runner_pool_generated():
	field_info.finished_generating_bulk_field.connect(on_field_pool_generated)
	
	field_info.generate_bulk_field_in_pool()
	
func on_field_pool_generated():
	on_data_ready()
func on_data_ready():
	field_info.choose_bulk_random_fields_from_pool(3)
	var all_runners:Array = runner_info.choose_bulk_random_runners_from_pool(3)
	runner_info.chosen_runners = all_runners
	%data_table.generate_dictionary()
	%field_data_table.generate_dictionary()
	$loan_shop.update_count()



func item_click_detection():

	user_data.procession.on_simulation_procession_list 
	var hovered_item:item = user_data.user_mouse.hovered_item 
	if hovered_item == null:

		return
	
	if hovered_item.item_price > user_data.current_user.held_cash:
		return

	var shop:Node = item_type_to_dedicated_shop[hovered_item.item_type]
	
	match hovered_item.item_type:
		"power_card":
			user_data.procession.post_shop_procession_list.append( {"item_type":hovered_item.item_type, "item_name":hovered_item.item_name,
			"applied_runner":applied_runner}
			)
			%user_data_panel.format_panel()
			
		"obstacle":
			var item_properties:Dictionary
			item_properties["image"] = user_data.user_mouse.hovered_item.base_sprite.texture
			user_data.procession.on_simulation_procession_list.append( {"item_type":hovered_item.item_type, "item_name":hovered_item.item_name,
			"applied_runner":applied_runner, "item_data":item_properties}
			)
		"climate_token":
			user_data.procession.post_shop_procession_list.append( {"item_type":hovered_item.item_type, "item_name":hovered_item.item_name,
			"applied_runner":applied_runner})
	user_data.user_mouse.hovered_item.delete()
	user_data.user_mouse.hovered_item = null
