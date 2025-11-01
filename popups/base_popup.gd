extends Sprite2D

enum State {
	HIDING_ANIM,
	SHOWING_ANIM,
	NOT_BUSY
}
@onready var current_state:State = State.NOT_BUSY
@onready var popup_name:Node = $name
@onready var popup_description:Node = $description
@export var animation_speed:float = 0.5
@export var hide_animation_speed:float = 0.25

@export var animation_type:Tween.TransitionType
var visibillity_tween:Tween 
var position_tween:Tween 
func popup_fade_in(initial_pos:Node2D,final_pos:Node2D):
	if not visibillity_tween == null:
		visibillity_tween.kill()
	if not position_tween == null:
		position_tween.kill()
	$name.text = user_data.user_mouse.hovered_item.item_name
	$description.text = user_data.user_mouse.hovered_item.description
	popup.global_position.x = initial_pos.global_position.x
	popup.global_position.y = initial_pos.global_position.y
	popup.global_scale = settings.menu_pixel_scale*Vector2.ONE
	visibillity_tween = popup.create_tween()
	position_tween = popup.create_tween()
	position_tween.tween_property(popup,"global_position",final_pos.global_position,animation_speed).set_trans(animation_type)
	visibillity_tween.tween_property(popup,"modulate:a",1,animation_speed).set_trans(animation_type)
func popup_fade_out(initial_pos:Node2D,final_pos:Node2D):
	if not visibillity_tween == null:
		visibillity_tween.kill()
	if not position_tween == null:
		position_tween.kill()
	popup.global_position.x = final_pos.global_position.x
	popup.global_position.y = final_pos.global_position.y
	popup.global_scale = settings.menu_pixel_scale*Vector2.ONE
	popup.modulate.a = 0
	popup.popup_name.text = ""
	popup.popup_description.text = ""
