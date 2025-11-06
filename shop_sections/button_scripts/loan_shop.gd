extends Node2D


@onready var item_type:String = "bank"


func update_count():
	$"get loan".update_count()
	%user_data_panel.format_panel()
