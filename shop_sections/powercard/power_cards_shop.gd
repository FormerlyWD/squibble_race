extends Node2D


@onready var base_powercard_ref:PackedScene = preload("res://shop_sections/powercard/items (powercards)/base_powercard.tscn")

@onready var default_card_amount:int = 4

@onready var powercard_pool_file:String = "res://shop_sections/powercard/items (powercards)/item_pool/"
@onready var powercard_format_name_to_path:Dictionary
@onready var necessary_procession_data:Array[String] = [
	"applied_runner",
	"applied_stat",
	"stat_change_type",
	"stat_change_value"
]
@onready var item_type:String = "power_card"
@onready var chosen_items:Array
@onready var item_pool:Dictionary = {
	
	
}


func _ready() -> void:
	extract_data_from_all_format_powercards(powercard_pool_file)
	select_cards_from_pool()
	reset()
	
func extract_all_cards_to_pool():
	pass
func extract_data_from_all_format_powercards(path) :
	var dir = DirAccess.open(path)
	var file_array:Array[String]
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			var powercard:Resource = load(path + file_name)
			item_pool[file_name.get_basename().capitalize()] = powercard
			
			file_name = dir.get_next()
	else:
		("An error occurred when trying to access the path.")
	return file_array
	

func select_cards_from_pool(amount:int = default_card_amount):
	var card_pool_names:Array = item_pool.keys()
	if card_pool_names.size() < amount:
		for excess_count in amount-card_pool_names.size():
			card_pool_names.append(card_pool_names[0])
	
	chosen_items = card_pool_names
			
func on_buy(item_name:String, applied_runner_index:int):
	var item_resource:Resource = item_pool[item_name]
	var applied_runner_stat_label:Label = %data_table.all_label_dict[item_resource.applied_stat][applied_runner_index]
	applied_runner_stat_label.text = str(get_new_value(item_resource.stat_change_type,float(applied_runner_stat_label.text),item_resource.stat_change_value) )
	
func reset(card_amount:int = default_card_amount):
	for already_initiated_cards in $all_cards.get_children():
		already_initiated_cards.queue_free()
	
	$all_cards.plot_card_points(card_amount)
	
	for count in card_amount:
		instanciate_card(item_pool[chosen_items[count]],
		chosen_items[count],
		Vector2($all_cards.plotted_points_x[count], $all_cards.position.y),
		$all_cards.popup_stacking_direction_points[count]
		)
		
		
		
func format_card(applied_stat:String,stat_change_type:String,stat_change_value:float, image:Texture):
	return {
		"applied_stat": applied_stat,
		"stat_change_type": stat_change_type,
		"stat_change_value": stat_change_value,
		"image":image
	}
	
	
func instanciate_card(item_resource:Resource, item_name:String, pos:Vector2, stacking_direction:Vector2i):
	var powercard:item = base_powercard_ref.instantiate()
	
	$all_cards.add_child(powercard)
	powercard.base_sprite.texture = item_resource.image
	powercard.item_path = powercard.get_path()
	powercard.item_type = item_type
	powercard.scale = settings.menu_pixel_scale*Vector2.ONE
	powercard.dynamic_description_scriptholder = self
	powercard.popup_stacking_direction = stacking_direction
	powercard.is_description_dynamic = true
	powercard.popup_stacking_direction
	powercard.item_name = item_name
	powercard.position = pos
	
func generate_description(item_name:String) -> String:
	var item_resource:powercard_format = item_pool[item_name]
	
	var base_change:String 
	
	var fetched_runner:Dictionary = runner_info.runner_pool[%runner_specification.selected_runner]
	var real_stat_name:String = runner_info.convert_display_name_to_real_name(item_resource.applied_stat)
	
	var change_preview:String
	var applied_runner_index:int = runner_info.chosen_runners.find(%runner_specification.selected_runner)
	var applied_runner_stat_label:Label = %data_table.all_label_dict[item_resource.applied_stat][applied_runner_index]
	var new_value:float = get_new_value(item_resource.stat_change_type,float(applied_runner_stat_label.text),item_resource.stat_change_value)
	var preview_value:float 
	change_preview = applied_runner_stat_label.text + "->" + str(new_value)
	if item_resource.stat_change_type == "%":
		base_change =  "+" + item_resource.stat_change_type + str(item_resource.stat_change_value) + " " + item_resource.applied_stat
		
		return base_change + " " + "(" + change_preview + ")" 
	base_change = item_resource.stat_change_type + str(item_resource.stat_change_value) + " " + item_resource.applied_stat
	return base_change + " " + "(" + change_preview + ")" 
	
func apply_effect( item_dict:Dictionary):
	if not item_dict.has("applied_runner"):
		item_dict["applied_runner"] = runner_info.chosen_runners[0]
	
	var card_dict:powercard_format = item_pool[item_dict["item_name"]]
	var fetched_runner:Dictionary = runner_info.runner_pool[item_dict["applied_runner"]]
	var real_stat_name:String = runner_info.convert_display_name_to_real_name(card_dict.applied_stat)
	
	fetched_runner[real_stat_name] = get_new_value(card_dict.stat_change_type, fetched_runner[real_stat_name],card_dict.stat_change_value)
	print(fetched_runner[real_stat_name])
	
func get_new_value(stat_change_type:String, base_value:float, card_value:float):
	match stat_change_type:
		"%":
			return base_value + (base_value * (card_value/100))
		"x":
			return base_value * card_value
		"+":
			return base_value + card_value
	
