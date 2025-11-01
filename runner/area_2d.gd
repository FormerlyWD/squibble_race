extends Area2D


@export var base_chance:int = 0
	
@onready var root_parent:CharacterBody2D = $".."

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	
	if root_parent.current_s == root_parent.MovingState.FALLING:
		return
		
		
	if area.get_parent().label == "obstacle":
		var obstacle:CharacterBody2D = area.get_parent()
		var added_chance:int = base_chance
		
		print(obstacle.obstacle_type)
			
		if root_parent.weaknesses.has(obstacle.obstacle_type):
			
			added_chance += obstacle.strength * root_parent.weakness_effectiveness
		elif root_parent.resistance.has(obstacle.obstacle_type):
			added_chance -= obstacle.strength * root_parent.resistance_effectiveness
			
		if root_parent.stat_value("strength")*5>added_chance+(obstacle.strength*5):
			if not obstacle.effect.size() == 0:
				root_parent.apply_effect(obstacle.effect)
			throw_obstacle(obstacle)
		else:
			fall(obstacle)
	elif area.get_parent().label == "character":
		var character:CharacterBody2D = area.get_parent()
		if root_parent.stat_value("strength")>(character.stat_value("strength")):
			character_collision(character)
		else:
			fall(character)

func throw_obstacle(obstacle_ref:CharacterBody2D):
	
	obstacle_ref.applied_force += root_parent.collision_strength*5
	obstacle_ref.throw()

func character_collision(character_ref:CharacterBody2D):
	character_ref.applied_force = root_parent.stat_value("strength")*5
	
	character_ref.start_falling()
func fall(x_ref:CharacterBody2D):
	root_parent.applied_force = x_ref.strength*5
	root_parent.start_falling()
