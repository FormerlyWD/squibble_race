extends Node2D

@onready var plotted_points:Array[Vector2]

@export var x_gap:float = 60/20
@export var y_gap:float = 60/20
@export var token_diameter:float = 16

func _ready() -> void:
	pass
	


	
func plot_token_points(amount:Vector2i):
	var scaled_token_diameter:float = token_diameter*settings.menu_pixel_scale
	var scaled_y_gap:float = y_gap*settings.menu_pixel_scale
	var scaled_x_gap:float = x_gap*settings.menu_pixel_scale
	
	for y_point in amount.y:
		var y:float = y_point*(scaled_token_diameter+scaled_y_gap)- (amount.y-1)*(scaled_token_diameter/2+scaled_y_gap/2)
		for x_point in amount.x:
			var x:float = x_point*(scaled_token_diameter+scaled_x_gap)- (amount.x-1)*(scaled_token_diameter/2+scaled_x_gap/2)
			plotted_points.append(Vector2(
				x,
				y
			))
			
			
			

			
	
