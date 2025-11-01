extends Node2D

@onready var plotted_points_x:Array[float]

@export var x_gap:float = 60
@export var card_diameter:float = 16

func _ready() -> void:
	pass
	


	
func plot_card_points(amount:int):
	var scaled_card_diameter:float = card_diameter*settings.menu_pixel_scale
	for point in amount:
		plotted_points_x.append(point*(scaled_card_diameter+x_gap)- (amount-1)*(scaled_card_diameter/2+x_gap/2))
		
