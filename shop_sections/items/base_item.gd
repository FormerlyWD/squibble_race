extends item

@export var popup_size_64px:bool = false
@onready var base_sprite:Sprite2D = $item_sprite
@onready var initial_pos:Node2D = $popup_detect/initial_pos
@onready var final_pos:Node2D = $popup_detect/final_pos
func delete():
	popup.popup_fade_out(initial_pos,final_pos)
	queue_free()
func _ready() -> void:
	pass
