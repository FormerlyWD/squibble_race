extends Node2D

@onready var cash_label:Label = $cash
@onready var debt_label:Label = $debt
@onready var name_label:Label = $name

func format_panel():
	cash_label.text = str(user_data.current_user.held_cash)
	debt_label.text = str(user_data.current_user.debt)
	name_label.text = user_data.current_user.user_name
