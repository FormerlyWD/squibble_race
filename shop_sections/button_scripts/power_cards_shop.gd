extends Node2D


@onready var base_powercard_ref:PackedScene = preload("res://shop_sections/items (powercards)/base_powercard.tscn")
@onready var necessary_procession_data:Array[String] = [
	"applied_runner",
	"applied_stat",
	"stat_change_type",
	"stat_change_value"
]
@onready var item_type:String = "climate_tokens"
@onready var item_pool:Dictionary = {
	"Motorpower":format_card("Acceleration","%",25, load("res://art/typings/typing_buttons/typing/typing1.png")),
}


func _ready() -> void:
	generate_cards(3)
	
func generate_cards(card_amount:int):
	$all_cards.plot_card_points(card_amount)
	var card_pool_names:Array = item_pool.keys()
	if card_pool_names.size() < card_amount:
		for excess_count in card_amount-card_pool_names.size():
			card_pool_names.append(card_pool_names[0])
	card_pool_names.shuffle()
	
	for count in card_amount:
		instanciate_card(item_pool[card_pool_names[count]],
		card_pool_names[count],
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
	powercard.description = generate_description(item_dict)
	powercard.item_name = item_name
	powercard.position = pos
	
func generate_description(item_dict:Dictionary) -> String:
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
	
	
