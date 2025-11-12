extends item

@export var popup_size_64px:bool = false
@onready var base_sprite:Sprite2D = $item_sprite
@onready var initial_pos:Node2D = $popup_detect/initial_pos
@onready var final_pos:Node2D = $popup_detect/final_pos


@onready var is_hovering:bool = false	

@onready var initial_popup_position:float
@onready var final_popup_position:float 
@export var animation_speed:float = 0.5
@export var hide_animation_speed:float = 0.25

@export var animation_type:Tween.TransitionType
var visibillity_tween:Tween 
var position_tween:Tween 

func delete():
	popup.popup_fade_out(initial_pos,final_pos)
	queue_free()
func _ready() -> void:
	pass


func _on_popup_detect_mouse_exited() -> void:
	if not user_data.user_mouse.hovered_item ==  self:
		return
	user_data.user_mouse.hovered_item = null
	popup.popup_fade_out(initial_pos,final_pos)


func _on_popup_detect_mouse_entered() -> void:
	if not user_data.user_mouse.hovered_item == null:
			return
	if is_description_dynamic:
		description = dynamic_description_scriptholder.generate_description(item_name)
	user_data.user_mouse.hovered_item = self
	popup.popup_fade_in(initial_pos,final_pos,popup_stacking_direction,["Acceleration"])
