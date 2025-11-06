extends Node2D


@onready var base_powercard_ref:PackedScene = preload("res://shop_sections/powercard/items (powercards)/base_powercard.tscn")

@onready var default_card_amount:int

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
			item_pool[file_name.get_basename().capitalize()] = extract_data_from_format_powercard(powercard)
			
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_array
	
	
func extract_data_from_format_powercard(powercard_format_ref:Resource) -> Dictionary:
	var empty_dictionary:Dictionary 
	empty_dictionary["applied_stat"] = powercard_format_ref.applied_stat 
	empty_dictionary["stat_change_type"] = powercard_format_ref.stat_change_type
	empty_dictionary["stat_change_value"] = powercard_format_ref.stat_change_value
	empty_dictionary["image"] = powercard_format_ref.image
	return empty_dictionary
func select_cards_from_pool(amount:int = default_card_amount):
	var card_pool_names:Array = item_pool.keys()
	if card_pool_names.size() < amount:
		for excess_count in amount-card_pool_names.size():
			card_pool_names.append(card_pool_names[0])
			
	chosen_items = card_pool_names
func reset(card_amount:int = default_card_amount):
	for already_initiated_cards in $all_cards.get_children():
		already_initiated_cards.queue_free()
	
	$all_cards.plot_card_points(card_amount)
	
	for count in card_amount:
		instanciate_card(item_pool[chosen_items[count]],
		chosen_items[count],
		Vector2($all_cards.plotted_points_x[count], $all_cards.position.y))
		
		
		
func format_card(applied_stat:String,stat_change_type:String,stat_change_value:float, image:Texture):
	return {
		"applied_stat": applied_stat,
		"stat_change_type": stat_change_type,
		"stat_change_value": stat_change_value,
		"image":image
	}
	
	
func instanciate_card(item_dict:Dictionary, item_name:String, pos:Vector2):
	var powercard:item = base_powercard_ref.instantiate()
	
	$all_cards.add_child(powercard)
	#powercard.base_sprite.texture = item_dict["image"]
	powercard.item_path = powercard.get_path()
	powercard.item_type = item_type
	powercard.scale = settings.menu_pixel_scale*Vector2.ONE
	powercard.dynamic_description_scriptholder = self
	powercard.is_description_dynamic = true
	powercard.item_name = item_name
	powercard.position = pos
	
func generate_description(item_name:String) -> String:
	var item_dict:Dictionary = item_pool[item_name]
	if item_dict["stat_change_type"] == "%":
		return "+" + item_dict["stat_change_type"] + str(item_dict["stat_change_value"]) + " " + item_dict["applied_stat"]
		
	return item_dict["stat_change_type"] + str(item_dict["stat_change_value"]) + " " + item_dict["applied_stat"]
func apply_effect(item_dict:Dictionary):
	if not item_dict.has("applied_runner"):
		item_dict["applied_runner"] = runner_info.chosen_runners[0]
	var fetched_runner:Dictionary = runner_info.runner_pool[item_dict["applied_runner"]]
	var fetched_card_stats:Dictionary = item_pool[item_dict["item_name"]]
	var real_stat_name:String = runner_info.convert_display_name_to_real_name(fetched_card_stats["applied_stat"])
	match fetched_card_stats["stat_change_type"]:
		"%":
			fetched_runner[real_stat_name] += fetched_runner[real_stat_name] * (fetched_card_stats["stat_change_value"]/100)
		"x":
			fetched_runner[real_stat_name] *= fetched_card_stats["stat_change_value"]
		"+":
			fetched_runner[real_stat_name] += fetched_card_stats["stat_change_value"]
	
	
