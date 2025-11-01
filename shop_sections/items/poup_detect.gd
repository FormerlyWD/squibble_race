extends Area2D
@onready var is_hovering:bool = false	

@onready var initial_popup_position:float
@onready var final_popup_position:float 
@export var animation_speed:float = 0.5
@export var hide_animation_speed:float = 0.25

@export var animation_type:Tween.TransitionType
var visibillity_tween:Tween 
var position_tween:Tween 
func _on_mouse_entered() -> void:
	if not user_data.user_mouse.hovered_item == null:
			return
	user_data.user_mouse.hovered_item = $".."
	popup.popup_fade_in($initial_pos,$final_pos)
	


func _on_mouse_exited() -> void:
	if not user_data.user_mouse.hovered_item ==  $"..":
		return
	user_data.user_mouse.hovered_item = null
	popup.popup_fade_out($initial_pos,$final_pos)
	
