extends Node


@onready var prerandomized_variances:Dictionary

@onready var buildset_path:String = "res://data/buildsets/"
@onready var default_values:Dictionary = {
	"recovery_speed_reduction" = 4,
	"health" = 5,
	
}
@onready var variance_names:Array[String]
@onready var variance_names_to_paths:Dictionary = {
	
}
@onready var variances:Dictionary = {
	"acceleration build":$"..".stat_format({},"",
	random.n(4,9)/2,
	0,
	random.n(0,7),
	random.n(1,10)/2,
	random.n(0,1)/2,
	4,
	["g","b"],
	["g","b"],
	{},
	random.n(1,10)/2,
	"acceleration build"
	),
	"speed build":$"..".stat_format({},"",
	random.n(0,1)/4,
	0,
	random.n(16.5 *2,40)/2,
	random.n(1,10)/2,
	random.n(0,1)/2,
	4,
	["g","b"],
	["g","b"],
	{},
	random.n(1,10)/2,
	"speed build"
	),
	"super acceleration build":$"..".stat_format({},"",
	random.n(0,1)/4,
	random.n(35,60)/100,
	random.n(16.5 *2,40)/2,
	random.n(1,10)/2,
	random.n(0,1)/2,
	4,
	["g","b"],
	["g","b"],
	{},
	random.n(1,10)/2,
	"super acceleration build"
	),
}
func get_random_variance_name() -> String:
	return variances.keys().pick_random()
func get_stat_from_variance(variance_name:String) -> Dictionary:
	match variance_name:
		"acceleration build":
			return $"..".stat_format(
			{},"",
			random.n(4,9)/2,
			0,
			random.n(0,7),
			random.n(1,10)/2,
			random.n(0,1)/2,
			4,
			[],
			[],
			{},
			random.n(1,10)/2,
			"acceleration build"
			)
		"speed build":
			return $"..".stat_format({},"",
			random.n(0,1)/4,
			0,
			random.n(16.5 *2,40)/2,
			random.n(1,10)/2,
			random.n(0,1)/2,
			4,
			[],
			[],
			{},
			random.n(1,10)/2,
			"speed build"
			)
		"super acceleration build":
			return$"..".stat_format({},"",
			0,
			random.n(35,60)/100,
			random.n(0,7),
			random.n(1,10)/2,
			random.n(0,1)/2,
			4,
			[],
			[],
			{},
			random.n(1,10)/2,
			"super acceleration build"
			)
	return {}
	
	
func dir_contents(path) :
	var dir = DirAccess.open(path)
	var file_array:Array[String]
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				variance_names_to_paths[file_name.get_basename()] = path + file_name
			else:
				variance_names_to_paths[file_name.get_basename()] = path + file_name
			variance_names.append(file_name.get_basename())
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_array
func read_file():
	dir_contents(buildset_path)
	var all_files:Array[String] 
	all_files.assign(variance_names_to_paths.values())
	for file_path in all_files:
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_string:String = file.get_as_text()
		var parse_result:Dictionary = JSON.parse_string(json_string)
		var int_based_parse_result:Dictionary
		var power_grade_count:int
		
		for all_p_grade in parse_result.values():
			power_grade_count +=1
			var intstat_dictionary_for_grade:Dictionary
			for all_stats in all_p_grade.keys():
				if all_p_grade[all_stats] == null:
					
					intstat_dictionary_for_grade[all_stats] = null
				elif typeof(all_p_grade[all_stats]) == TYPE_FLOAT:
					intstat_dictionary_for_grade[all_stats] = [0,0,0]
				else:
					
					var text_split:Array[String]
					var split:Array = Array(all_p_grade[all_stats].split(","))
					text_split.assign(split)
					var intarray:Array[int]
					for number in text_split:
						intarray.append(int(number))
					intstat_dictionary_for_grade[all_stats] = intarray
				# extract weaknesses resistance and stuff
			int_based_parse_result[power_grade_count] = intstat_dictionary_for_grade

		file.close()
		prerandomized_variances[variance_names_to_paths.find_key(file_path)] = int_based_parse_result
func _ready() -> void:
	read_file()
	$"..".create_new_runner_profile()
	$"..".create_new_runner_profile()
func get_random_variance() -> String:
	var random_variance_num:int = random.n(0,variance_names.size()-1)
	return variance_names[random_variance_num]
