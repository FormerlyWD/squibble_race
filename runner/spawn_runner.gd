extends Node

signal finished_bulk_generation
signal finished_runner_generation


@onready var names:Array[String]
@onready var is_runner_pool_generated
@onready var variance_node_ref:Node = $variance
@onready var typings_ref:Node = $typings
var display_name_to_real_name:Dictionary = {
	"Name" : "runner_name",
	"S. Acceleration": "quadratic_acceleration"
}
var auto_real_name_to_display_name:Dictionary
@export var amount_of_runners_in_pool:int = 30
@onready var runner_ranking:Array[String]
@export var start_runner_name_pool:Array[String] = [
	"Ae",
	"Je",
	"Na",
	"Pa",
	"Pu",
	"Zy",
	"En",
	"Yo",
	"Ga",
	"Bn",
	"Qr",
	"Xy",
	"Zq"
]
@export var end_runner_name_pool:Array[String] = auto_inherit_start_runner_name_pool()
@onready var runner_pool:Dictionary
@onready var chosen_runners:Array
enum Status {
	CREATING_BULK,
	CREATING_OTHER,
	AVAILABLE
}








@onready var current_status:Status = Status.CREATING_BULK
@onready var bulk_generation_num_left:int = 0

func auto_inherit_start_runner_name_pool() -> Array[String]:
	var array_string:Array[String]
	for names in start_runner_name_pool:
		array_string.append(names.to_lower())
		
	return array_string
func stat_format(
	appearance_data:Dictionary,
	runner_name:String,
	acceleration:float,
	quadratic_acceleration:float,
	speed:float,
	strength:float,
	recovery_speed_reduction:float,
	collision_strength:float,
	weaknesses:Array,
	resistance:Array,
	abillities:Dictionary,
	health:float,
	variance:String = "",
	power_grade:int = 0
) -> Dictionary:
	return {
		"appearance_data":appearance_data,
		"name":runner_name,
		"acceleration":acceleration,
		"quadratic_acceleration":quadratic_acceleration,
		"speed":speed,
		"strength":strength,
		"recovery_speed_reduction":recovery_speed_reduction,
		"collision_strength":collision_strength,
		"weaknesses":weaknesses,
		"resistance":resistance,
		"abillities":abillities,
		"health":health,
		"variance":variance,
		"power_grade":power_grade
	}
	
func convert_display_name_to_real_name(display_name:String) -> String:
	var stat_name:String
	if display_name_to_real_name.keys().has(display_name):
		
		stat_name = display_name_to_real_name[display_name]
	else:
		stat_name = display_name.to_lower()
	return stat_name
func convert_real_name_to_display_name(real_name:String) -> String:
	var stat_name:String
	if display_name_to_real_name.values().has(real_name):
		stat_name = display_name_to_real_name.find_key(real_name)
	else:
		stat_name = real_name.capitalize()
	return stat_name
func apply_dictionary_stats(chosen_runner:CharacterBody2D, stats:Dictionary) -> void:
	chosen_runner.runner_name = stats["runner_name"]
	for stat in stats.keys():
		print(stat)
		chosen_runner.stats[stat] = {
			"base":stats[stat],
			"modifier":100
		}
func _ready() -> void:
	finished_bulk_generation.connect(on_bulk_runner_generation_finished)
	finished_runner_generation.connect(on_runner_generation_finished)
func create_bulk_runner_profiles(custom_amount:int = -1):
	if custom_amount == -1:
		custom_amount = amount_of_runners_in_pool
	bulk_generation_num_left = custom_amount
	
	create_new_runner_profile()
func on_runner_generation_finished():
	if current_status == Status.CREATING_BULK:
		bulk_generation_num_left -=1
		if bulk_generation_num_left ==0:
			current_status == Status.AVAILABLE
			emit_signal("finished_bulk_generation")
			
		elif bulk_generation_num_left > 0:
			#(bulk_generation_num_left)
			create_new_runner_profile()
	
func on_bulk_runner_generation_finished():pass

func create_new_runner_profile():
	
	
	var variance:String = $variance.get_random_variance()
	var power_grade:int = random.n(1,3)
	
	var runner_name_num_start:int =  random.n(1,start_runner_name_pool.size()-1)
	var runner_name_start:String = start_runner_name_pool[runner_name_num_start]
	var runner_name_num_end:int =  random.n(0,end_runner_name_pool.size()-1)
	var runner_name_end:String = end_runner_name_pool[runner_name_num_end]
	var runner_name:String = runner_name_start +runner_name_end
	var stat_format:Dictionary = {
	}
	stat_format["appearance_data"] = {}
	stat_format["runner_name"] = runner_name
	stat_format["variance"] = variance
	stat_format["power_grade"] = power_grade
	match power_grade:
		1:
			stat_format["payout"] = 4
		2: 
			stat_format["payout"] = 3
		3:
			stat_format["payout"] = 2
	stat_format["abillities"] = []

	for stats in $variance.prerandomized_variances[variance][power_grade].keys():
		var min:int = $variance.prerandomized_variances[variance][power_grade][stats][0]
		var max:int = $variance.prerandomized_variances[variance][power_grade][stats][1]
		var div:int =  $variance.prerandomized_variances[variance][power_grade][stats][2]
		stat_format[stats] = random.n(min,max)/div
		if is_nan(stat_format[stats]):
			stat_format[stats] = 0
	$typings.get_weaknesses_and_resistance(power_grade,stat_format)
	runner_pool[runner_name] = stat_format
	
	emit_signal("finished_runner_generation")
func choose_random_runner_from_pool():
	var random_choice:int = random.n(0,runner_pool.size()-1)
	return runner_pool.values()[random_choice]
func choose_bulk_random_runners_from_pool(amount:int) -> Array:
	var runner_values_randomized = runner_pool.keys()
	var empty_array:Array
	runner_values_randomized.shuffle()
	for chosen_count in amount:
		empty_array.append(runner_values_randomized[chosen_count])
	return empty_array
