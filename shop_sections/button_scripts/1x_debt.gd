extends Button
@export var debt_amount:int
func _on_pressed() -> void:
	user_data.current_user.held_cash += debt_amount
	user_data.current_user.debt += debt_amount
	
	$"..".update_count()
