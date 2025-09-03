extends Node

var all_obstacle_types:Array[String] = [
	"Electricity",
	"Oil",
	"Iron"
]

func get_weaknesses_and_resistance(power_grade:int, dictionary:Dictionary) :
	if power_grade == 1:
		dictionary["weaknesses"] = all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]
	elif power_grade == 2:
		var weakness = all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]
		var proto_obstacle_types:Array[String] = all_obstacle_types
		dictionary["weaknesses"] =weakness
		proto_obstacle_types.erase(weakness)
		dictionary["resistance"] = proto_obstacle_types[random.n(0,proto_obstacle_types.size()-1)]
	elif power_grade == 3:
		dictionary["resistance"] = all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]
		
