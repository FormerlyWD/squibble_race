extends Node

@onready var all_obstacle_types:Array[String] = [
	"Electricity",
	"Oil",
	"Iron"
]
@onready var all_obstacle_type_to_color:Dictionary = {
	"Electricity": "#db4422",
	"Oil": "#ffda80",
	"Iron": "#228f66"
}
@onready var all_obstacle_type_to_image:Dictionary = {
	"Electricity":load("res://art/typings/typing_buttons/typing/typing3.png"),
	"Oil":load("res://art/typings/typing_buttons/typing/typing2.png"),
	"Iron":load("res://art/typings/typing_buttons/typing/typing1.png")
}
func get_weaknesses_and_resistance(power_grade:int, dictionary:Dictionary) :
	if power_grade == 1:
		dictionary["weaknesses"] =[ all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]]
		dictionary["resistance"] = []
	elif power_grade == 2:
		var weakness = [all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]]
		dictionary["weaknesses"] =weakness
		dictionary["resistance"] = [all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]]
		if dictionary["weaknesses"] == dictionary["resistance"]:
			dictionary["weaknesses"] = []
			dictionary["resistance"] = []
	elif power_grade == 3:
		dictionary["resistance"] = [all_obstacle_types[random.n(0,all_obstacle_types.size()-1)]]
		dictionary["weaknesses"] = []
