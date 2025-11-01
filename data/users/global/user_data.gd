extends Node

signal finished_user_cycle
signal next_user
@onready var user_collection:Node = %user_collection_and_generation
@onready var user_class:Node = $user_class
@onready var user_mouse:Node = $user_mouse
@onready var procession:Node = $item_procession
@onready var control:Node = $set_data_control
@onready var current_user:user 

@onready var user_dict:Dictionary 

@onready var all_selectable_usernames:Array[String] = [
	"Waleed",
	"Someone",
	"Someone else"
]
func get_controller() -> user:
	return user_data.user_dict[user_data.control.assigned_controller]

func change_current_user():
	current_user = get_controller()
