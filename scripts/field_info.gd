extends Node


signal finished_generating_field
signal finished_generating_bulk_field
@onready var display_name_to_real_name:Dictionary = {
	"obstacle ds.":"obstacle_density"
}
@onready var chosen_weather:Array[String] = [

	"Clear"
]
@onready var artificial_weather:Array[String] = [
	"Electricity",
	"Electricity",
	"Electricity",
	"Electricity",
	"Electricity",
	"Electricity"
]
var chosen_aesthetic:Node2D
@onready var chosen_length_ft:int = 40
@onready var chosen_obstacle_density:String = "low"
@onready var chosen_name:String = ""

enum Status {
	CREATING_BULK,
	CREATING_OTHER,
	AVAILABLE
}
@onready var current_status:Status = Status.AVAILABLE
@onready var fields_left_generating:int
@onready var pixel_to_feet:float = 2.5/14
@onready var amount_of_fields_generated:int = 30
@onready var all_possible_obstacle_densities:Dictionary = {
	"no obstacles":0,
	"low":4,
	"medium":8,
	"high":12
}


@onready var chosen_fields:Array[Dictionary]
@onready var field_selection_pool:Array[Dictionary]
@onready var all_possible_lengths_ft:Array = [
	20,
	25,
	30,
	35,
	40
]

@onready var start_name_pool:Array[String] = [
	"Eana",
	"Tyr's",
	"Razor",
	"Jyrn",
	"Foln's",
	"Asphin"
]
@onready var mid_name_pool:Array[String] = [
	"macin",
	"phno",
	"heli",
	"qiue",
	"jane",
	"unmin"
]
@onready var end_name_pool:Array[String] = [
	"ville",
	"terra",
	"fann",
	"lock"
]
@onready var field_pool:Array[Dictionary] = [
]

func _ready() -> void:
	connect("finished_generating_field",on_field_generated)
	connect("finished_generating_bulk_field",on_bulk_field_generated)

func on_field_generated():
	if current_status ==Status.AVAILABLE:
		return
	fields_left_generating -=1
	if fields_left_generating > 0:
		generate_field_in_pool()
	else:
		current_status = Status.AVAILABLE
		emit_signal("finished_generating_bulk_field")
func on_bulk_field_generated():
	pass
	
func apply_field_data(selected_field_num:int):
	chosen_name = chosen_fields[selected_field_num-1]["name"]
	chosen_obstacle_density = chosen_fields[selected_field_num-1]["obstacle_density"]
	chosen_weather = chosen_fields[selected_field_num-1]["weather"]
	chosen_length_ft = chosen_fields[selected_field_num-1]["length"]
	
	pass

func generate_field_in_pool():
	var field_name:String = start_name_pool.pick_random() +" "+ mid_name_pool.pick_random() + end_name_pool.pick_random()
	var length:int = all_possible_lengths_ft.pick_random()
	var r_typing:String  = runner_info.typings_ref.all_obstacle_types.pick_random()
	var obstacle_density:String = all_possible_obstacle_densities.keys().pick_random()
	var if_weather_is_clear_rand:int = random.n(1,2)
	var weather_mix:Array[String]
	if if_weather_is_clear_rand ==1:
		weather_mix= [
			r_typing,
			"clear",
			"clear",
			"clear",
			"clear"
		] 
	else:
		weather_mix = ["clear"]
	
	field_pool.append({
		"name":field_name,
		"length":length,
		"obstacle_density":obstacle_density,
		"weather":weather_mix
	}) 
	
	if current_status == Status.CREATING_BULK:
		emit_signal("finished_generating_field")
func generate_bulk_field_in_pool():
	fields_left_generating = amount_of_fields_generated
	current_status = Status.CREATING_BULK
	generate_field_in_pool()
func choose_bulk_random_fields_from_pool(amount_of_fields:int):
	field_pool.shuffle()
	var field_array:Array[Dictionary]
	for count in amount_of_fields:
		field_array.append(field_pool[count])
	chosen_fields = field_array
