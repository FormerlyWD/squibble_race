extends Button

@onready var count:int

func _ready() -> void:
	user_data.next_user.connect(update_count)
	
func _on_pressed() -> void:
	var c_user:user = user_data.get_controller()
	if c_user.held_cash < c_user.debt:
		c_user.debt = c_user.debt-c_user.held_cash
		c_user.held_cash = 0
	else:
		c_user.held_cash = c_user.held_cash-c_user.debt
		c_user.debt = 0
	
	text = "Pay debt: (" + str(c_user.debt) + ")"
func update_count():
	if user_data.current_user.debt == user_data.current_user.held_cash:
		count = 0
	elif user_data.current_user.debt > user_data.current_user.held_cash:
		count = user_data.current_user.held_cash
	else:
		count = user_data.current_user.debt
	text = "Pay debt: (" + str(count) + ")"
