extends Node

class_name ObstacleButton

@export var min:float
@export var max:float
@export var expression:String
@export var inverse_expression:String
@export var targeted_stat:String
@export var starting_value:float = 100
@export var base_image:Texture2D


func fetch_image_from_sprite():
	base_image = get_parent().texture
