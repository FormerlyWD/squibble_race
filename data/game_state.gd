extends Node

signal GAME_ESSENTIAL_INFO_READY
signal ROUND_READY
enum Location {
	MAINMENU,
	SHOPMENU,
	SIMULATION,
	NEWS
}

var round_count:int = 0

@onready var debug_mode:bool = false
@onready var state_and_location:Dictionary ={
	Location.MAINMENU:"res://main_menu/main_menu.tscn",
	Location.SHOPMENU:"res://scenes/gamble_menu.tscn",
	Location.SIMULATION:"res://scenes/main_scene.tscn"
}
@onready var current_game_state:Location = Location.MAINMENU
@onready var debt_modifier:int = 3


func _ready() -> void:
	pass
	
func change_scene(location_type:Location):
	get_tree().change_scene_to_file(state_and_location[location_type])
	current_game_state = location_type
func create_new_game():
	
	user_data.user_collection.generate_users(2)

	runner_info.finished_bulk_generation.connect(on_runner_pool_generated)
	runner_info.create_bulk_runner_profiles()
func on_runner_pool_generated():
	user_data.user_collection.apply_default_stats()
	
	field_info.finished_generating_bulk_field.connect(game_info_ready)

	field_info.generate_bulk_field_in_pool()
	
func pick_data():
	runner_info.chosen_runners =runner_info.choose_bulk_random_runners_from_pool(3)
	field_info.choose_bulk_random_fields_from_pool(3)
func game_info_ready():
	pick_data()
	
	emit_signal("GAME_ESSENTIAL_INFO_READY")
	initiate_round()
func initiate_round():
	("happened 2 times")
	round_count +=1
	current_game_state = Location.SHOPMENU
	emit_signal("ROUND_READY")
	
	
