extends Node2D
enum State {
	HIDING_ANIM,
	SHOWING_ANIM,
	NOT_BUSY
}

@onready var popup_reference:PackedScene = load("res://popups/base_popup.tscn")
@onready var all_current_extra_popups:Array
@onready var current_state:State = State.NOT_BUSY
@onready var primary_popup_name:Node = $primary_popup/name
@onready var primary_popup_description:Node = $primary_popup/description
@export var animation_speed:float = 0.5
@export var hide_animation_speed:float = 0.25

@export var additive_position:float = 1.75


@export var definition_dict:Dictionary = {
	"Acceleration":"Rate of change in Acceleration"
}
@export var animation_type:Tween.TransitionType
var visibillity_tween:Tween
var position_tween:Tween 

func popup_fade_in(initial_pos:Node2D,final_pos:Node2D, more_info_stacking_direction:Vector2i = Vector2i(-1,0),more_info:Array[String] = []): 
	for b_popup in all_current_extra_popups:
		b_popup.queue_free()
		all_current_extra_popups.erase(b_popup)
	if not visibillity_tween == null: visibillity_tween.kill()
	if not position_tween == null: position_tween.kill()
	
	print(more_info_stacking_direction)
	primary_popup_name.text = user_data.user_mouse.hovered_item.item_name
	primary_popup_description.text = user_data.user_mouse.hovered_item.description
	
	
	
	$".".global_position= initial_pos.global_position
	
	
	$".".global_scale = settings.menu_pixel_scale*Vector2.ONE
	
	visibillity_tween= popup.create_tween()
	position_tween= popup.create_tween()
	
	var count:int = 0
	for popup_string in more_info:
		count += 1
		var new_popup:Sprite2D =  popup_reference.instantiate()
		add_child(new_popup)
		all_current_extra_popups.append(new_popup)
		
		new_popup.position += additive_position*more_info_stacking_direction*count*settings.menu_pixel_scale
		new_popup.get_node("name").text = popup_string
		new_popup.get_node("description").text  = "hi"
		
		
		
	position_tween.tween_property(self,"global_position",final_pos.global_position,animation_speed).set_trans(animation_type)
	
	visibillity_tween.tween_property(self,"modulate:a",1,animation_speed).set_trans(animation_type)
	
	
	
	
func popup_fade_out(initial_pos:Node2D,final_pos:Node2D):
	#for b_popup in all_current_extra_popups:
		#b_popup.queue_free()
		#all_current_extra_popups.erase(b_popup)
	if not visibillity_tween == null: visibillity_tween.kill()
	if not position_tween == null: position_tween.kill()
	
	global_position.x = final_pos.global_position.x
	global_position.y = final_pos.global_position.y
	global_scale = settings.menu_pixel_scale*Vector2.ONE
	modulate.a = 0
	primary_popup_name.text = ""
	primary_popup_description.text = ""
	
