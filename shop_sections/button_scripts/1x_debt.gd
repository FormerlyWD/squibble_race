extends Button
@export var debt_amount:int
func _on_pressed() -> void:
	user_data.get_controller().held_cash += debt_amount
	user_data.get_controller().debt += debt_amount
	
	$"../get loan".update_count()
