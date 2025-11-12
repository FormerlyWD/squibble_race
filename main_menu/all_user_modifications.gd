extends VBoxContainer
@onready var user_modification_bar:PackedScene = preload("res://ui_elements/user_huds/user_modification/user_modification_bar.tscn")



func add_users(amount:int):
	var actual_amount:int = amount-1
	for count in actual_amount:
		var new_user_modif:HBoxContainer = user_modification_bar.instantiate()
		add_child(new_user_modif)
		
func apply_modifications():
	var count:int = 1
	for user_modif_bar in get_children():
		user_data.user_dict[count].user_name = user_modif_bar.name_text_edit.text 
		count +=1
