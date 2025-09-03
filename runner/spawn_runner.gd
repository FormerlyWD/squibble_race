extends Node




@onready var names:Array[String]

@onready var variance_node_ref:Node = $variance

var start_runner_name_pool:Array[String] = [
	"Aero",
	"Aze",
	"Bane",
	"Bana",
	"Cama",
	"Dyno",
	"Fephora",
]
var end_runner_name_pool:Array[String] = [
	"binn",
	"crame",
	"dem",
	"da",
	"fax",
	"jae",
	"jin",
	"qeri",
	"wano"
]
@onready var runner_pool:Dictionary




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
		"runner_name":runner_name,
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
func import_dictionary_stats(chosen_runner:CharacterBody2D, stats:Dictionary) -> void:
	chosen_runner.appearance_data = stats["appearance_data"]
	chosen_runner.runner_name = stats["runner_name"]
	chosen_runner.acceleration = stats["acceleration"]
	chosen_runner.quadratic_acceleration = stats["quadratic_acceleration"]
	chosen_runner.speed = stats["speed"]
	chosen_runner.strength = stats["strength"]
	chosen_runner.recovery_speed_reduction= stats["recovery_speed_reduction"]
	chosen_runner.collision_strength =stats["collision_strength"]
	chosen_runner.weaknesses= stats["weaknesses"]
	chosen_runner.resistance =stats["resistance"]
	chosen_runner.abillities= stats["abillities"]
	chosen_runner.health= stats["health"]
	
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
	stat_format["abillities"] = []
	for stats in $variance.prerandomized_variances[variance][power_grade].keys():
		var min:int = $variance.prerandomized_variances[variance][power_grade][stats][0]
		var max:int = $variance.prerandomized_variances[variance][power_grade][stats][1]
		var div:int =  $variance.prerandomized_variances[variance][power_grade][stats][2]
		stat_format[stats] = random.n(min,max)/div
		
	$typings.get_weaknesses_and_resistance(power_grade,stat_format)
	runner_pool[runner_name] = stat_format
	
