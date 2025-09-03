extends Area2D


@export var base_chance:int = 5
	


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if $"..".current_s == $"..".MovingState.FALLING:
		return
	if area.get_parent().label == "obstacle":
		var obstacle:CharacterBody2D = area.get_parent()
		if $"..".strength*5>base_chance+(obstacle.strength*5):
			throw_obstacle(obstacle)
		else:
			fall(obstacle)
	elif area.get_parent().label == "character":
		var character:CharacterBody2D = area.get_parent()
		if $"..".strength*5>(character.strength*5):
			character_collision(character)
		else:
			fall(character)

func throw_obstacle(obstacle_ref:CharacterBody2D):
	obstacle_ref.scale += Vector2(0.1,0.1)
	obstacle_ref.applied_force += $"..".collision_strength*5
	obstacle_ref.throw()

func character_collision(character_ref:CharacterBody2D):
	character_ref.applied_force = $"..".strength*5
	character_ref.start_falling()
func fall(x_ref:CharacterBody2D):
	$"..".applied_force = x_ref.strength*5
	$"..".start_falling()
