extends Node2D
@onready var base_token_ref:PackedScene = preload("res://shop_sections/items/base_item.tscn")
@onready var item_type:String = "climate_token"
@onready var item_pool:Dictionary = {}
@onready var name_sorted_token_pool:Dictionary
@onready var token_actions_and_properties:Dictionary = {
	"resistance":{"image":load("res://art/typings/typing_buttons/action/action_buttons3.png")},
	"weaknesses":{"image":load("res://art/typings/typing_buttons/action/action_buttons2.png")},
	"additions":{"image":load("res://art/typings/typing_buttons/action/action_buttons1.png")}
}
@onready var inverse_of_action:Dictionary = {
	"resistance":"weaknesses",
	"weaknesses":"resistance"
}
@onready var naming_convention_for_action:Dictionary = {
	"resistance":"Resistor",
	"weaknesses":"Weakenor",
	"additions":"Adder"
}
@onready var token_typings_and_properties:Dictionary = {
	"Oil":{"image":load("res://art/typings/typing_buttons/typing/typing2.png")},
	"Electricity":{"image":load("res://art/typings/typing_buttons/typing/typing3.png")},
	"Iron":{"image":load("res://art/typings/typing_buttons/typing/typing1.png")}
}
func _ready() -> void:
	pass
	generate_tokens(Vector2i(4,1))

func instanciate_dict():
	for action in token_actions_and_properties.keys():

		for typing in token_typings_and_properties.keys():
			var token_name:String = get_name_from_data(typing,action)
			var token_description:String = get_description_from_data(typing,action)
			item_pool[[typing,action] ] ={"name":token_name, "description":token_description}
			name_sorted_token_pool[token_name] = [typing,action]
func generate_tokens(vcount:Vector2i):
	pass
	$all_tokens.plot_token_points(vcount)
	instanciate_dict()
	var token_properties:Array = item_pool.keys()
	token_properties.shuffle()
	 
	var count:int = 0
	for point in $all_tokens.plotted_points:
		instanciate_token(
			point,
			token_properties[count][0],
			token_properties[count][1]
		)
		count+=1

func get_name_from_data(typing:String,action:String):
	match action:
		"additions":
			return typing.capitalize() + " " + "Adder" 
		"resistance":
			return typing.capitalize() + " " + "Resistor" 
		"weaknesses":
			return typing.capitalize() + " " + "Weakenor" 
func get_description_from_data(typing:String,action:String):
	match action:
		"additions":
			return "Adds a gist of " + typing +  " into the atmosphere for this round."
		"resistance":
			return "Makes the chosen runner resistant to " + typing
		"weaknesses":
			return  "Makes the chosen runner weakenned to " + typing
func get_popup_info(typing:String,action:String):
	pass
func instanciate_token(pos:Vector2, typing_name:String, action_string:String):
	var token:item = base_token_ref.instantiate()
	var token_name:String = item_pool[[typing_name,action_string]]["name"]
	var token_description:String = item_pool[[typing_name,action_string]]["description"]
	var action_image:Texture2D = token_actions_and_properties[action_string]["image"]
	var typing_image:Texture2D = token_typings_and_properties[typing_name]["image"]
	var typing_sprite:Sprite2D = Sprite2D.new()
	
	
	$all_tokens.add_child(token)
	
	
	token.base_sprite.texture = action_image
	typing_sprite.texture = typing_image
	token.item_name = item_pool[[typing_name,action_string]]["name"]
	token.description = item_pool[[typing_name,action_string]]["description"]
	token.item_type = item_type
	token.scale = settings.menu_pixel_scale*Vector2.ONE
	
	token.position = pos
	token.add_child(typing_sprite)
	
	token.item_path = token.get_path()
func apply_effect(item_dict:Dictionary):
	var token_name:String = item_dict["item_name"]
	var speculative_chosen_runner:String = item_dict["applied_runner"]
	var data_array:Array = name_sorted_token_pool[token_name]
	var action:String = data_array[1]
	var typing:String = data_array[0]
	if action == "additions":
		field_info.artificial_weather.append(typing)
		return
	else:
		var fetched_runner:Dictionary = runner_info.runner_pool[speculative_chosen_runner]
		

				
		if not fetched_runner[action].has(typing):
			fetched_runner[action].append(typing)
		if fetched_runner[inverse_of_action[action]].has(typing):
			fetched_runner[inverse_of_action[action]].erase(typing)
			
		
