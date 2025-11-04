extends HBoxContainer


@onready var all_rows:Array[Node] = get_children()
@onready var all_label_dict:Dictionary 

@onready var sprite_ref:Sprite2D = Sprite2D.new()
@export var gap_for_the_origin_point_x:float = 557.994
@export var starting_origin_point_x:float = -638.784
@export var weakness_y_pos:float =  345.844
@export var resistance_y_pos:float =515.843
@export var detect_weakness_resist_positions_automatically:bool = false
@onready var typing_radius:float = 8
@export var typing_scale:int= 10
@export var dynamic_typing_icons:bool = false

func generate_dictionary() -> void:
	var all_label_dictionary:Dictionary
	# 0
	# speed: [x,y,z]
	for stat in all_rows[0].get_children():
		if detect_weakness_resist_positions_automatically and dynamic_typing_icons:
			match runner_info.convert_display_name_to_real_name(stat.text):
				"resistance":

					resistance_y_pos = stat.global_position.y
				"weaknesses":

					weakness_y_pos = stat.global_position.y
		all_label_dictionary[runner_info.convert_display_name_to_real_name(stat.text)] = []
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
			var stat_name:String = first_row[stat_count]
			
			#
			var capitalized_name:String = runner_info.chosen_runners[row_count-1]
			capitalized_name.capitalize()

			var stat_value =  runner_info.runner_pool[capitalized_name][stat_name]
			
			all_label_dictionary[stat_name].append(stat_label)
			if typeof(stat_value) == TYPE_ARRAY:
				if stat_value.size() == 0:
					pass
				elif not dynamic_typing_icons:
					stat_label.text = str(stat_value[0])
				else:
					var origin_point_x:float = starting_origin_point_x + (gap_for_the_origin_point_x *(row_count-1) )
					var origin_point_y:float = 0
					match stat_name:
						"resistance":
							origin_point_y = resistance_y_pos
						"weaknesses":
							origin_point_y = weakness_y_pos
					typing_previewer(Vector2(origin_point_x, origin_point_y),stat_value,stat_label)
					
			else:
				stat_label.text = str(stat_value)
				
			stat_count +=1
	all_label_dict = all_label_dictionary
	all_rows.push_front(node_first_row)
func get_origin_point_from_label_dict(row:int,stat_name:String):
	return Vector2(
		all_label_dict[runner_info.convert_display_name_to_real_name(stat_name)][0].global_position.y,
		starting_origin_point_x + (gap_for_the_origin_point_x *(row-1) )
	)
func typing_previewer(origin_point:Vector2,array:Array,container:Label):
	container.text = ""
	var typing_element_parsed:int = 0
	for type in array:
		container.position.x -= typing_radius*typing_scale
		#
		var typing_sprite:Sprite2D = Sprite2D.new()
		$"../../..".add_child(typing_sprite)
		typing_sprite.scale = typing_scale*Vector2.ONE*%runner_ui.scale.x
		typing_sprite.texture = runner_info.typings_ref.all_obstacle_type_to_image[type]
		#
		typing_sprite.global_position = origin_point
		typing_sprite.global_position.x += typing_element_parsed*typing_radius*typing_scale*%runner_ui.scale.x
		typing_element_parsed +=1
