extends VBoxContainer

@onready var all_rows:Array[Node] = get_children()

@onready var selected_field_pool:Array[int]
@onready var user_checklist:Array[int]
func convert_display_name_to_real_name(display_name:String) -> String:
	var stat_name:String
	stat_name = display_name.to_lower()
	if field_info.display_name_to_real_name.keys().has(stat_name):
		stat_name = field_info.display_name_to_real_name[stat_name]
	return stat_name
func convert_real_name_to_display_name(real_name:String) -> String:
	var stat_name:String
	stat_name = real_name.capitalize()
	return stat_name
func generate_dictionary() -> Dictionary:
	var all_label_dictionary:Dictionary
	# 0
	# speed: [x,y,z]
	for stat_name in all_rows[0].get_children():
		all_label_dictionary[stat_name.text] = []
	# rest
	var first_row:Array = all_label_dictionary.keys()
	var node_first_row:Node = all_rows[0]
	all_rows.erase(all_rows[0])
	
	var row_count:int = 0
	for row in all_rows:
		row_count +=1
		var stat_count:int = 0
		for stat_label in row.get_children():
			if stat_count >= first_row.size():
				break
			var display_name:String = first_row[stat_count]
			var stat_name:String = convert_display_name_to_real_name(display_name)
			var stat_value = field_info.chosen_fields[row_count-1][stat_name]
			all_label_dictionary[display_name].append(stat_label)
			stat_label.text = str(stat_value)
			if typeof(stat_value) == TYPE_ARRAY:
				if stat_value[0] == "clear":
					stat_label.text = "clear"
				else:
					stat_label.text = str(stat_value[0])
			
			stat_count +=1
	
	all_rows.push_front(node_first_row)
	return all_label_dictionary
