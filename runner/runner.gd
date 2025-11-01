extends CharacterBody2D


@export var runner_name:String = "e"
@export var appearance_data:Dictionary
@export var acceleration:float = 5
@export var quadratic_acceleration:float = 0
@export var speed:float = 0.1
@export var strength:float = 50
@export var recovery_speed_reduction:float = 2


@export var stats_dict:Dictionary = {
	"speed":{"base":50, "modifier":{}},
	"acceleration":{"base":0, "modifier":{}},
	"quadratic_acceleration":{"base":0, "modifier":{}},
	"strength":{"base":3, "modifier":{}},
	"recovery_speed_reduction":{"base":1, "modifier":{}},
}
@export var effects:Array[Dictionary] = [
	
]
@onready var effect_count:int
var is_stats_initiated:bool = false
@export var collision_strength:float = 4
@export var weaknesses:Array[String] = [
]
@export var resistance:Array[String] = [
]
@export var abillities:Dictionary = {
	"ball fetcher":"base"
}
@export var health:int
@export var weakness_effectiveness:int = 1.5
@export var resistance_effectiveness:int = 1.5
@onready var falling_fatique:Dictionary = {
	"targeted_stat":"speed",
	"initial":0,
	"final":100,
	"transition_type":Tween.TransitionType.TRANS_LINEAR,
	"duration":3,
	"special_decay_properties":{
		"decay_disabled":true
		
	}
}
var variance
var pixel_to_feet:float = 2.5/14
var applied_force:float

@onready var label:String = "character"
@onready var payout:int
var distance_reached:float
var runner_order:int = 0
var reached_the_end:bool = false
enum MovingState {
	STATIC,
	FALLING,
	RUNNING
}
var current_s:MovingState = MovingState.STATIC



func parse_effects(delta:float):
	var afflicted_stats:Array[String]
	for effect in effects:
		var new_expr:Expression = Expression.new()
		var x:float = effect["value"]
		var d:float = delta
		var parse 
		
		if effect["state"] == "inverse":
			parse = new_expr.parse(effect["inverse_expression"],["x","d"])
		else:
			parse = new_expr.parse(effect["expression"],["x","d"]) 
		var result:float = new_expr.execute([x,d],self) 
		print(result)

		if result <= effect["min"] or result >= effect["max"]:

			if effect["state"] == "normal":
				print(result)
				effect["state"] = "inverse"
			else:
				print(result)
				effects.erase(effect)
				
				if not afflicted_stats.has(effect["targeted_stat"]):
					stats_dict[effect["targeted_stat"]]["modifier"] = 1
				return
		
		effect["value"] = result
		if afflicted_stats.has(effect["targeted_stat"]):
			stats_dict[effect["targeted_stat"]]["modifier"] *= result/100 
		else: stats_dict[effect["targeted_stat"]]["modifier"] = result/100
		afflicted_stats.append(effect["targeted_stat"])
		
		
func _ready() -> void:
	pass
func start_moving():
	$facemovement.play("move")
	current_s = MovingState.RUNNING

func apply_effect(effect_dict:Dictionary):
	effect_count +=1 #uniqify the effect reference
	var current_effect_count:int = effect_count
	print("lets go?")
	
	
	var initial_v:float = effect_dict["initial"]
	var final_v:float = effect_dict["final"]
	var transition:Tween.TransitionType = effect_dict["transition_type"]
	var duration:float = effect_dict["duration"]
	
	effects.append(effect_dict) 
	stats_dict[effect_dict["targeted_stat"]]["modifier"][str(current_effect_count)] = effect_dict["initial"]
	

	
	# growth
	var growth_tween:Tween = create_tween()
	var property_string_name:String = "stats_dict:" + effect_dict["targeted_stat"] + ":modifier:" + str(current_effect_count)
	growth_tween.tween_property(self,
	property_string_name,final_v,duration).set_trans(transition)
	print(property_string_name)
	# decay
	await growth_tween.finished
	var is_decay_disabled:bool = false
	if effect_dict.has("special_decay_properties"):
		if effect_dict["special_decay_properties"]["decay_disabled"] == false:
			initial_v = effect_dict["special_decay_properties"]["initial"]
			final_v = effect_dict["special_decay_properties"]["final"]
			transition = effect_dict["special_decay_properties"]["transition_type"]
			duration= effect_dict["special_decay_properties"]["duration"]
		else:
			is_decay_disabled = true
	
	
	
	if not is_decay_disabled:
		var decay_tween:Tween = create_tween()

		decay_tween.tween_property(self,
		property_string_name,initial_v,duration
		).set_trans(transition)


		await decay_tween.finished
	
	effects.erase(effect_dict) 
	stats_dict[effect_dict["targeted_stat"]]["modifier"].erase(current_effect_count)
	
	
func apply_stats(applied_stats:Dictionary):
	for stat in applied_stats.keys():
		stats_dict[stat] = {
			"base":applied_stats[stat],
			"modifier":{}
		}
	is_stats_initiated = true
func start_falling():
	var stored_speed:float = stats_dict["speed"]["base"]
	current_s = MovingState.FALLING
	$facemovement.play("fall")
	var recovery:SceneTreeTimer = get_tree().create_timer((applied_force/5)-stat_value("recovery_speed_reduction"))
	await recovery.timeout

	apply_effect(falling_fatique.duplicate())
	stats_dict["speed"]["base"] = stored_speed
	start_moving()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		start_moving()
	
func stat_value(stat_name:String,delta:float = 1):
	
	if stats_dict.has(stat_name):
		if typeof(stats_dict[stat_name]["base"]) == TYPE_FLOAT or typeof(stats_dict[stat_name]["base"]) == TYPE_INT:
			var percentage:float = 1
			if stats_dict[stat_name]["modifier"].size() > 0:
				for modifier_value in stats_dict[stat_name]["modifier"].values():
					percentage*= float(modifier_value)/100
			return (stats_dict[stat_name]["base"])*percentage
		else:
			return (stats_dict[stat_name]["base"])
	else:
		return null
func _physics_process(delta: float) -> void:
	
	
	if current_s == MovingState.RUNNING:
		
		
		
		
		var afflicted_quadratic_acceleration:float = stat_value("quadratic_acceleration")
		stats_dict["acceleration"]["base"] += stat_value("quadratic_acceleration",delta) * delta
		
		var afflicted_acceleration:float = stat_value("acceleration")
		stats_dict["speed"]["base"] += stat_value("acceleration",delta) * delta
		
		var afflicted_speed:float = stat_value("speed")
		velocity.x = stat_value("speed",delta)
		
		var speed_scale:float = velocity.length()  / (14.0/0.6)
		if speed_scale <0 or speed_scale ==0:
			$facemovement.speed_scale = 0.1
		else:
			$facemovement.speed_scale = speed_scale
		
	elif current_s == MovingState.FALLING:
		
		if stat_value("speed")<0.001:
			stats_dict["speed"]["base"] = 0
		else:
			stats_dict["speed"]["base"] -= stats_dict["speed"]["base"]/(10)
		
		var afflicted_speed:float = stat_value("speed")
		velocity.x = afflicted_speed
		velocity.y = afflicted_speed*5
			
	if (position.x >= ref.measurement_points.ending_line) and not reached_the_end:
		reached_the_end = true
		ref.signal_win.emit_signal("reached_end",stats_dict["runner_name"]["base"])
		
	
	if not reached_the_end:
		ref.UI_run[runner_order-1].text = str(round(position.x *pixel_to_feet)) + " " + "Ft."
	
	move_and_slide()
	

func deplete_health(subtraction_value:int):
	if stat_value("health") - subtraction_value <= 0:
		stats_dict["health"]["base"] = 0
		applied_force = 90000
	else:
		stats_dict["health"]["base"] -= subtraction_value
	
	
