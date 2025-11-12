extends Node2D

signal data_ready

@onready var pixel_art_scale:int = 10

@onready var item_type_to_dedicated_shop:Dictionary= {
	"power_card":$all_shop_sections/power_card_shop,
	"obstacle":$all_shop_sections/obstacle_shop,
	"climate_token":$all_shop_sections/climate_token_shop,
	"bank":$all_shop_sections/bank,
	"assasination":$all_shop_sections/assasination_shop
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
	item_type_to_dedicated_shop["power_card"].reset()
	item_type_to_dedicated_shop["climate_token"].reset()
	item_type_to_dedicated_shop["obstacle"].reset()
	item_type_to_dedicated_shop["assasination"].reset()
func parsed_all_users():
	
	user_data.procession.post_shop_procession()
	
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
	if user_data.user_mouse.hovered_item == null:

		return
	
	if user_data.user_mouse.hovered_item.item_price > user_data.current_user.held_cash:
		return
	put_item_action_in_queue(user_data.user_mouse.hovered_item)
	user_data.user_mouse.hovered_item.delete()
	user_data.user_mouse.hovered_item = null


func put_item_action_in_queue(hovered_item:item):
	var shop:Node = item_type_to_dedicated_shop[hovered_item.item_type]
	
	match hovered_item.item_type:
		"power_card":
			put_general_actions_in_queue(user_data.QueueState.POST_SHOP,hovered_item.item_type,hovered_item.item_name)
			shop.on_buy(hovered_item.item_name, runner_info.chosen_runners.find(%runner_specification.selected_runner))
			%user_data_panel.format_panel()
		"climate_token": 
			put_general_actions_in_queue(user_data.QueueState.POST_SHOP,hovered_item.item_type,hovered_item.item_name)
		
		"obstacle": # on_simulation queue needs info stored for later
			var item_properties:Dictionary = shop.item_pool[hovered_item.item_name]
			item_properties["image"] = user_data.user_mouse.hovered_item.base_sprite.texture
			
			put_general_actions_in_queue(user_data.QueueState.SIMULATION,hovered_item.item_type,hovered_item.item_name, item_properties)
		"assasination":
			put_general_actions_in_queue(user_data.QueueState.POST_SHOP,hovered_item.item_type,hovered_item.item_name)

func put_general_actions_in_queue(
	queue_state:user_data.QueueState,
	item_type:String,
	item_name:String,
	item_data = {},
	custom_runner_name:String = ""
):
	var selected_runner:String = %runner_specification.selected_runner
	if not custom_runner_name == "":
		selected_runner = custom_runner_name
	if queue_state == user_data.QueueState.SIMULATION:
		user_data.procession.on_simulation_procession_list.append( {
			"item_type":item_type,
			 "item_name":item_name,
			"applied_runner":selected_runner,
			 "item_data":item_data
			}
			)
	elif queue_state == user_data.QueueState.POST_SHOP:
		user_data.procession.post_shop_procession_list.append( {
			"item_type":item_type,
			 "item_name":item_name,
			"applied_runner":selected_runner
			}
			)
