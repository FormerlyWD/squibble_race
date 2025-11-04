extends Node

@onready var base_user:PackedScene = preload("res://data/users/base_user.tscn")

@export var amount_of_users:int = 3
func generate_users(amount:int):
	amount = amount_of_users
	for user_count in amount:
		var new_user:user = base_user.instantiate()
		new_user.user_number = user_count+1
		$"..".user_dict[new_user.user_number] = new_user
		add_child(new_user)
		new_user.betted_runner_number = 0

func apply_random_stats_for_debug():
	pass
	for base_user in get_children():
		var specified_user:user = base_user
		specified_user.betted_runner_number = [1,2,3].pick_random()
		specified_user.held_cash = [1,2,3].pick_random()*100
		specified_user.user_name = $"..".all_selectable_usernames.pick_random()
		specified_user.debt = [1,2,3].pick_random()*50
