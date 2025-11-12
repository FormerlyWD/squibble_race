extends Node2D


func _ready() -> void:
	game_info.create_new_game()
	
		
	$all_user_modifications.add_users(user_data.amount_of_users)
